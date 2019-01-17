# promptmunge.sh


# func to add to prompt cmd (unlike the model pathmunge, this only allows adding after)
promptcmdmunge() {
    if ! echo "$PROMPT_COMMAND" | tr \; \\n | sed 's/^ *//;s/ *$//' | grep -Fx "$1" &>/dev/null ; then
        PROMPT_COMMAND="${PROMPT_COMMAND:+${PROMPT_COMMAND} ; }$1"
    fi
}

