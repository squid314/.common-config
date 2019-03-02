# helpful stuff for working with this common config

# common-config update command
confup() {
    git --work-tree="${CONFIG_ROOT}" \
        --git-dir="${CONFIG_ROOT}/.git" \
        pull --ff-only \
        && \
        source ~/.bashrc
}
