# devenvs.sh

if ! type docker &>/dev/null && ! type podman &>/dev/null ; then return ; fi

__dev_cont() {
    # if tool is selected, use that one
    if [[ $(bget bashrc.d.devenvs.sh.tool) ]] ; then
        bget bashrc.d.devenvs.sh.tool
    else
        # otherwise, detect available tool and default to docker
        if type docker &>/dev/null ; then
            echo docker
        else
            echo podman
        fi
    fi
}

dev() {
    local tag="$(bget bashrc.d.devenvs.sh.family)"
    if [[ -z $tag ]] ; then tag=redhat8 ; fi
    case "$1" in
        t|tool)
            case "$2" in
                p|pod|podman)  tool=podman ;;
                d|dock|docker) tool=docker ;;
                unset)         tool= ;;
                "")
                    if [[ $(bget bashrc.d.devenvs.sh.tool) ]] ; then
                        echo "Current tool: $(bget bashrc.d.devenvs.sh.tool)"
                    else
                        echo "Current tool: <unset> (evaluated: $(__dev_cont))"
                    fi
                    return 0 ;;
                *) echo "Invalid tool '$2'." ; return 1 ;;
            esac
            bset bashrc.d.devenvs.sh.tool $tool
            ;;
        f|fam|family)
            case "$2" in
                c7|cent7|centos7)     family=centos7 ;;
                c8|cent8|centos8)     family=centos8 ;;
                c9|cent9|centos9)     family=centos9 ;;
                c|cent|centos)        family=centos9 ;;
                r7|rh7|rhel7|redhat7) family=redhat7 ;;
                r8|rh8|rhel8|redhat8) family=redhat8 ;;
                r9|rh9|rhel9|redhat9) family=redhat9 ;;
                r|rh|rhel|redhat)     family=redhat9 ;;
                d|deb|debian)         family=debian ;;
                "") echo "Current family: $(bget bashrc.d.devenvs.sh.family)" ; return 0 ;;
                *) echo "Invalid family '$2'." ; return 1 ;;
            esac
            bset bashrc.d.devenvs.sh.family $family
            ;;
        pull) $(__dev_cont) pull quay.io/squid314/devenv:$tag ;;
        start)
            if [[ "$($(__dev_cont) container ls -aqf name=devenv-$tag | wc -l)" -eq 1 ]] ; then
                $(__dev_cont) start devenv-$tag &>/dev/null
            else
                if [[ -z "$($(__dev_cont) image ls -q quay.io/squid314/devenv:$tag)" ]] ; then
                    $(__dev_cont) image pull quay.io/squid314/devenv:$tag || return 1
                fi
                local dev devs=()
                for dev in $(cd $HOME/dev 2>/dev/null && find * -type d -prune) ; do
                    if bconf "bashrc.d.devenvs.sh.devs.$dev=mount" ; then
                        devs=("${devs[@]}" -v "$HOME/dev/$dev:/home/squid/dev/$dev")
                    fi
                done
                if [[ $(__dev_cont) = docker ]] ; then
                    if   [[ -S /var/run/docker.sock         ]] ; then dock_sock="-v         /var/run/docker.sock:/var/run/docker.sock"
                    elif [[ -S /private/var/run/docker.sock ]] ; then dock_sock="-v /private/var/run/docker.sock:/var/run/docker.sock"
                    fi
                fi
                if [[ $(__dev_cont) = podman ]] ; then
                    # may work on linux; doesn't work on mac os with vm separation
                    userns="--userns=keep-id"
                fi
                $(__dev_cont) run -d --init \
                    --name devenv-$tag \
                    ${dock_sock} \
                    ${userns} \
                    -v squid-dev:/home/squid/dev \
                    "${devs[@]}" \
                    quay.io/squid314/devenv:$tag \
                    tail -f /dev/null &>/dev/null
            fi
            ;;
        stop)
            if [[ "$($(__dev_cont) container ls -qf name=devenv-$tag | wc -l)" -eq 1 ]] ; then
                $(__dev_cont) stop devenv-$tag &>/dev/null
            fi
            ;;
        rm)
            if [[ "$($(__dev_cont) container ls -aqf name=devenv-$tag | wc -l)" -eq 1 ]] ; then
                $(__dev_cont) container rm -f devenv-$tag &>/dev/null
            fi
            ;;
        clean) dev stop && dev rm ;;
        run)
            shift
            if [[ $# -eq 0 ]] ; then
                # pull in the default cmd for the image
                set - $($(__dev_cont) image inspect --format '{{join .Config.Cmd " "}}' quay.io/squid314/devenv:$tag)
            fi
            $(__dev_cont) exec -it \
                devenv-$tag \
                "$@"
            ;;
        *) dev start && dev run "$@" ;;
    esac
}
