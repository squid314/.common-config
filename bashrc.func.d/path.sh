# pathmunge.sh

# function to manage components of user's PATH
path() {
    local -a p ; IFS=: read -ra p <<<"$PATH"

    local pc inc
    local cmd="$1"; shift
    case "$cmd" in
        add)
            local tail
            if [[ $1 = --tail || $1 = --after ]] ; then
                tail=yes
                shift
            fi
            for inc in "$@" ; do
                if ! path has "$inc" ; then
                    if [[ $tail ]] ; then
                        p+=("$inc")
                    else
                        p=("$inc" "${p[@]}")
                    fi
                fi
            done
            ;;
        has|contains)
            inc="$1"
            for pc in "${p[@]}" ; do
                if [[ $inc = $pc ]] ; then
                    return 0
                fi
            done
            return 1
            ;;
        rm|remove|delete)
            for inc in "$@" ; do
                # allow numeric values (would anyone use just a number as a path component?)
                if [[ $inc -eq $inc ]] 2>&- ; then
                    unset p[$inc]
                else
                    for pc in "${!p[@]}" ; do
                        if [[ $inc = ${p[$pc]} ]] ; then
                            unset __prompt_commands[$pc]
                        fi
                    done
                fi
            done
            ;;
        mv|move)
            path rm "$@" # if there is an option provided, it will be fine
            path add "$@"
            ;;
        clean)
            local -a p2
            for pc in "${p[@]}" ; do
                # remove any blanks and also delete any entries which are relative to the current directory (a security concern)
                if [[ "$pc" && "${pc:0:1}" != . ]] && ! __array_has p2 "$pc" ; then
                    p2+=("$pc")
                fi
            done
            # restack into p
            p=("${p2[@]}")
            ;;
        list|ls)
            for pc in "${!p[@]}" ; do
                printf 'path[%s]=%q\n' $pc "${p[$pc]}"
            done
            # don't need to re-eval the PATH
            return 0
            ;;
        *)
            printf 'error: %s: unrecognized command "%s"\n' "$0" "$cmd"
            return 1
            ;;
    esac
    # not actually needed every call...
    IFS=: eval PATH='"${p[*]}"'
}
