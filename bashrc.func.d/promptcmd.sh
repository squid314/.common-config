# promptcmd.sh

PROMPT_COMMAND=promptcmd\ run
__prompt_commands=()

# function to manage commands run before prompt display
promptcmd() {
    local __exit=$? # must occur first for `run`; everything else is gravy

    local pc inc
    local cmd="$1" ; shift
    case "$cmd" in
        run)
            for pc in "${__prompt_commands[@]}" ; do
                # $__exit is exposed to the command running since $? has been trampled
                # by this point. it is a local variable, so if the user needs it, they
                # must pull it on the eval line. for example, 'echo "last exit code of
                # $__exit is `[ $__exit = 0 ] && echo good || echo bad`"'. in contrast,
                # a function called will not have access to the variable unless passed
                eval $pc
            done
            ;;
        add)
            for inc in "$@" ; do
                if ! promptcmd has "$inc" ; then
                    __prompt_commands+=("$inc")
                fi
            done
            ;;
        has|contains)
            inc="$1"
            for pc in "${__prompt_commands[@]}" ; do
                if [[ $pc = $inc ]] ; then
                    return 0
                fi
            done
            return 1
            ;;
        rm|remove|delete)
            for inc in "$@" ; do
                # allow numeric values (would anyone use just a number as the command itself?)
                if [[ $inc -eq $inc ]] 2>&- ; then
                    unset __prompt_commands[$inc]
                else
                    for pc in "${!__prompt_commands[@]}" ; do
                        if [[ $inc = ${__prompt_commands[$pc]} ]] ; then
                            unset __prompt_commands[$pc]
                        fi
                    done
                fi
            done
            ;;
        mv|move)
            promptcmd rm "$@"
            promptcmd add "$@"
            ;;
        clean)
            local -a pc2
            for pc in "${__prompt_commands[@]}" ; do
                # remove any blanks
                if [[ "$pc" ]] && ! __array_has pc2 "$pc" ; then
                    pc2+=("$pc")
                fi
            done
            # restack all commands back to the front of the array
            __prompt_commands=("${pc2[@]}")
            ;;
        list|ls)
            for pc in "${!__prompt_commands[@]}" ; do
                printf '__prompt_commands[%s]=%q\n' $pc "${__prompt_commands[$pc]}"
            done
            ;;
        *)
            printf 'error: %s: unrecognized command "%s"\n' "$0" "$cmd"
            return 1
            ;;
    esac
}
