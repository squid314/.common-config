# bashrc.func.d/alias.sh

recomplete() {
    if complete -p "$2" &>/dev/null ; then
        eval $(complete -p "$2" | sed "s;$2$;$1;")
    fi
}

alias() {
    local ret al a b
    builtin alias "$@"
    ret=$?
    for al in "$@" ; do
        # assigning a simple command alias
        # (checking for spaces or semi-colons is not the best, but it's pretty good)
        if [[ "$al" == *=* && "${al##*[ ;]*}" ]] ; then
            a="${al%%=*}"
            b="${al#*=}"
            recomplete "$a" "$b"
        fi
    done
    return $ret
}

# vim: ts=4 sts=4 sw=4 et ft=sh :
