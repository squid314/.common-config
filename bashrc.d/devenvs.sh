# devenvs.sh

if ! type docker &>/dev/null && ! type podman &>/dev/null ; then return ; fi


if type podman &>/dev/null ; then
    __dev_cont() { podman "$@"; }
else
    __dev_cont() { docker "$@"; }
fi

dev() {
    local tag="$(bget bashrc.d.devenvs.sh.family)"
    if [[ -z $tag ]] ; then tag=redhat8 ; fi
    case "$1" in
        f|fam|family)
            case "$2" in
                c7|cent7|centos7)                      family=centos7 ;;
                c|cent|centos|c8|cent8|centos8)        family=centos8 ;;
                r7|rh7|rhel7|redhat7)                  family=redhat7 ;;
                r|rh|rhel|redhat|r8|rh8|rhel8|redhat8) family=redhat8 ;;
                d|deb|debian)                          family=debian ;;
                *) echo "Invalid family '$2'." ; return 1 ;;
            esac
            bset bashrc.d.devenvs.sh.family $family
            ;;
        check) __dev_cont pull quay.io/squid314/devenv:$tag ;;
        start)
            if [[ "$(__dev_cont container ls -qf name=devenv-$tag | wc -l)" -eq 1 ]] ; then
                __dev_cont start devenv-$tag &>/dev/null
            else
                local dev devs=()
                for dev in $(cd $HOME/dev 2>/dev/null && find * -type d -prune) ; do
                    if bconf "bashrc.d.devenvs.sh.devs.$dev=mount" ; then
                        devs=("${devs[@]}" -v "$HOME/dev/$dev:/home/squid/dev/$dev")
                    fi
                done
                if   [[ -S /var/run/docker.sock         ]] ; then dock_sock="-v         /var/run/docker.sock:/var/run/docker.sock"
                elif [[ -S /private/var/run/docker.sock ]] ; then dock_sock="-v /private/var/run/docker.sock:/var/run/docker.sock"
                fi
                __dev_cont run -d --init \
                    --name devenv-$tag \
                    ${dock_sock} \
                    -v squid-dev:/home/squid/dev \
                    "${devs[@]}" \
                    quay.io/squid314/devenv:$tag \
                    tail -f /dev/null &>/dev/null
            fi
            ;;
        stop)
            if [[ "$(__dev_cont container ls -qf name=devenv-$tag | wc -l)" -eq 1 ]] ; then
                __dev_cont stop devenv-$tag &>/dev/null
            fi
            ;;
        rm)
            if [[ "$(__dev_cont container ls -qf name=devenv-$tag | wc -l)" -eq 1 ]] ; then
                __dev_cont container rm -f devenv-$tag &>/dev/null
            fi
            ;;
        clean)
            dev stop
            dev rm
            ;;
        run)
            shift
            if [[ $# -eq 0 ]] ; then
                # pull in the default cmd for the image
                set - $(__dev_cont image inspect --format '{{join .Config.Cmd " "}}' quay.io/squid314/devenv:$tag)
            fi
            __dev_cont exec -it \
                devenv-$tag \
                "$@"
            ;;
        *)
            dev start
            dev run "$@"
            ;;
    esac
}
