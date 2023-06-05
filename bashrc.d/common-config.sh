# helpful stuff for working with this common config

# common-config update command
confup() {
    if [[ $* = -f ]] ; then
        git --work-tree="${CONFIG_ROOT}" \
            --git-dir="${CONFIG_ROOT}/.git" \
            reset --hard
    fi && \
    git --work-tree="${CONFIG_ROOT}" \
        --git-dir="${CONFIG_ROOT}/.git" \
        pull --ff-only \
        && \
        source ~/.bashrc \
        && \
        if [[ $TMUX ]] ; then
            tmux source-file ~/.tmux.conf
        fi
}
