# tmux.sh
# tmux things

# tmux remote connect
tmr() {
    if [ $# == 0 ] ; then echo 'um... you need to give me a destination, e.g. "squid@blmq.us"' >&2 ; return 1 ; fi
    local host="$1" ; shift
    # provide fallback tmux command
    if [ $# == 0 ] ; then
        set "new-session" "-A"
    fi
    # use mosh if it is available
    if type mosh &>/dev/null ; then
        echo "running \`mosh $host -- tmux $@\`"
        mosh "$host" -- tmux "$@"
    else
        echo "running \`ssh $host -t -- tmux $@\`"
        ssh "$host" -t -- tmux "$@"
    fi
}
