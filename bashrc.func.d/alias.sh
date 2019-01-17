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
            if complete -p "$b" &>/dev/null ; then
                eval $(complete -p "$b" | sed "s;$b$;$a;")
            fi
        fi
    done
    return $ret
}
