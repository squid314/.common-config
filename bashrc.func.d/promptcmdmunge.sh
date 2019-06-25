# promptcmdmunge.sh

PROMPT_COMMAND=__prompt_command
__prompt_commands=()

__prompt_command() {
    local __exit=$? # must occur first; everything else is gravy
    local pc

    for pc in "${__prompt_commands[@]}" ; do
        # $__exit is exposed to the command running since $? has been trampled
        # by this point. it is a local variable, so if the user needs it, they
        # must pull it on the eval line. for example, 'echo "last exit code of
        # $__exit is `[ $__exit = 0 ] && echo good || echo bad`"'. in contrast,
        # a function called will not have access to the variable
        eval $pc
    done
}

# func to add to prompt cmd (unlike the model pathmunge, this only allows adding after)
promptcmdmunge() {
    local pc
    for pc in "${__prompt_commands[@]}" ; do
        if [[ $pc = $1 ]] ; then
            return 0
        fi
    done
    __prompt_commands=( "${__prompt_commands[@]}" "$1" )
}
