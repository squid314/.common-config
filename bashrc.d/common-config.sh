# helpful stuff for working with this common config

# common-config update command
confup() {
    if [[ $* = -f ]] ; then
        git --work-tree="${CONFIG_ROOT}" \
            --git-dir="${CONFIG_ROOT}/.git" \
            reset --hard @{upstream} # technically this may not always work, but if you run it a second time, it should
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
