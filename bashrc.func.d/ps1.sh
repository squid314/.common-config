# ps1.sh

__ps1_parts=(
    'PS1=""'
    'PS1="$PS1\[\e]0;\w$__git_ps1_value\007"'
    'PS1="$PS1$__ps1_bold_blue$__ps1_userhost$__ps1_reset "'
    # could separate these
    'PS1="$PS1$__ps1_bold_green\w$__git_ps1_value$__ps1_reset "'
    'if [ "$__exit" -eq 0 ] ; then PS1="$PS1$__ps1_face_success " ; else PS1="$PS1$__ps1_face_failure " ; fi'
    'PS1="$PS1${VIRTUAL_ENV+$__ps1_yellow#}"'
    'PS1="$PS1${__ps1_jobs+$__ps1_yellow&}"'
    'PS1="$PS1$__ps1_red\$$__ps1_reset "'
)

__ps1_face_success="$__ps1_bold_green:)$__ps1_reset"
__ps1_face_failure="$__ps1_bold_red:($__ps1_reset"

__ps1_userhost='\u@\h'
if bconf 'bashrc.ps1.userhost=useronly' ; then __ps1_userhost='\u' ; fi

# function to manage generation of parts of PS1
ps1() {
    local pc inc
    local cmd="$1" ; shift
    case "$cmd" in
        run)
            local __exit="$1"
            for pc in "${__ps1_parts[@]}" ; do
                # $__exit is exposed to the command running onoly via the local. use in the eval
                eval $pc
            done
            ;;
        add)
            __ps1_parts+=("$@")
            ;;
        insert|ins)
            inc="$1"
            pc="$2"
            if ! [ "$inc" -eq "$inc" ] 2>/dev/null ; then
                printf 'error: %s: non-numeric index "%s"\n' "$0" "$cmd"
                return 1
            fi
            __ps1_parts=("${__ps1_parts[@]:0:$inc}" "$pc" "${__ps1_parts[@]:$inc}")
            ;;
        has|contains)
            inc="$1"
            for pc in "${__ps1_parts[@]}" ; do
                if [[ $pc = $inc ]] ; then
                    return 0
                fi
            done
            return 1
            ;;
        rm|remove|delete)
            for inc in "$@" ; do
                # allow numeric values
                if [ "$inc" -eq "$inc" ] 2>/dev/null ; then
                    unset __ps1_parts[$inc]
                else
                    for pc in "${!__ps1_parts[@]}" ; do
                        if [[ $inc = ${__ps1_parts[$pc]} ]] ; then
                            unset __ps1_parts[$pc]
                        fi
                    done
                fi
            done
            ;;
        mv|move)
            ps1 rm "$@"
            ps1 add "$@"
            ;;
        clean)
            local -a pc2
            for pc in "${__ps1_parts[@]}" ; do
                # remove any blanks or dups
                if [[ "$pc" ]] && ! __array_has pc2 "$pc" ; then
                    pc2+=("$pc")
                fi
            done
            # restack all commands back to the front of the array
            __ps1_parts=("${pc2[@]}")
            ;;
        list|ls)
            for pc in "${!__ps1_parts[@]}" ; do
                printf '__ps1_parts[%s]=%q\n' $pc "${__ps1_parts[$pc]}"
            done
            ;;
        *)
            printf 'error: %s: unrecognized command "%s"\n' "$0" "$cmd"
            return 1
            ;;
    esac
}
