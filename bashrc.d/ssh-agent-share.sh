# ssh-agent-share.sh

# This set of commands provides a way to ensure that only one ssh-agent(1) is running at a time and to be able to clean it up when there are no more shells
# using it. It does this by adding a special agent-info directory to a user's .ssh directory and storing required metadata there. This metadata consists of the
# connection info of the current running agent as well as all shells which are currently connecting to it.

AGENT_INFO_DIR="${HOME}/.ssh/agent-info"
AGENT_INFO_FILE="${AGENT_INFO_DIR}/info"

function agent {
    if [ $# = 0 ] ; then
        agent verify && agent add
        return $?
    fi

    case "$1" in
        create) # start a new agent and record its info
            new_agent=`mktemp /tmp/agent.XXXXXXXX`
            [ $? != 0 ] && echo Unable to create a temp file. >&2 && return 1
            ssh-agent | head -n 2 > $new_agent

            # if an info file exists, then we assume that it is extraneous and due to an unclean exit of a shell (possibly during shutdown) and just clean
            # everything up
            if [ -f $AGENT_INFO_FILE ] ; then
                bash -c "
# pull the old info in
source $AGENT_INFO_FILE
# ask the agent to quit
ssh-agent -k
# if it is still alive, force kill it
ps -ef | awk '{print \$2}' | grep \"\$SSH_AGENT_PID\" >&/dev/null && ( sleep 2 ; kill -9 \"\$SSH_AGENT_PID\" )
# clean up any shell registrations
rm -f $AGENT_INFO_FILE $AGENT_INFO_DIR/sh-*
" >&/dev/null
            fi

            mv $new_agent $AGENT_INFO_FILE
            ;;
        attach) # load info into current shell, test the new connection, and add current shell to list of attached shells
            source $AGENT_INFO_FILE >&/dev/null && ssh-add -l >&/dev/null
            # ssh-add -l returns 0 if there are identities and 1 if there are none, but returns 2 if the connection fails; so we look explicitly for 2
            [ $? != 2 ] && touch $AGENT_INFO_DIR/sh-$$
            ;;
        detach) # remove current shell from attached shells and clean up agent if no remaining attached shells
            rm $AGENT_INFO_DIR/sh-$$
            # if we were the last shell listening, then clean up the agent and info file
            if echo $AGENT_INFO_DIR/sh-* | grep '*' >&/dev/null ; then
                ssh-agent -k
                rm $AGENT_INFO_FILE
            fi
            ;;
        verify) # verify that an agent exists and the current shell is attached; if not, attach, creating if necessary
            # tests:
            # - have PID data?
            # - have socket data?
            # - current data matches data in info file?
            # - socket is valid?
            # - PID is alive? (note that we don't check if it is the right process)
            # - can connect to agent?
            # - current shell is registered?
            # TODO since we now check if we can connect to the agent (ssh-add -l), do we need to check anything before that?
            if [ -z "$SSH_AGENT_PID" ] || \
                    [ -z "$SSH_AUTH_SOCK" ] || \
                    [ ! -S $SSH_AUTH_SOCK ] || \
                    bash -c "source $AGENT_INFO_FILE && [ \"\$SSH_AGENT_PID\" = \"$SSH_AGENT_PID\" ] && [ \"\$SSH_AUTH_SOCK\" = \"$SSH_AUTH_SOCK\" ]" || \
                    ! ps -ef | awk '{print $2}' | grep "$SSH_AGENT_PID" >&/dev/null || \
                    ! bash -c "ssh-add -l ; [ \$? = 2 ] && exit 1 || exit 0" >&/dev/null || \
                    [ ! -f "$AGENT_INFO_DIR/sh-$$" ]
            then
                # first, attempt to just attach. failing that, create and then attach
                if ! agent attach ; then
                    agent create && agent attach
                fi
            fi
            ;;
        add) # add private keys to the agent
            shift
            local keys_to_add=(~/.ssh/*id_*sa)
            if [ $# != 0 ] ; then
                keys_to_add=("$@")
            fi
            ssh-add "${keys_to_add[@]}"
            ;;
        show) # show the current agent info; primarily usefull for debugging
            # compare current environment to what is in the agent info file, if it exists
            if [ ! -f "${AGENT_INFO_FILE}" ] ; then
                echo No agent info file detected at "${AGENT_INFO_FILE}".
                return 1
            else
                bash <<COMPARE_ENV_STATE_SCRIPT
source $AGENT_INFO_FILE
result=0
if [ "\$SSH_AGENT_PID" != "$SSH_AGENT_PID" ] ; then
    echo Agent PIDs do not match: "expected: \"\$SSH_AGENT_PID\"   current: \"$SSH_AGENT_PID\""
    result=1
fi
if [ "\$SSH_AUTH_SOCK" != "$SSH_AUTH_SOCK" ] ; then
    echo Agent sockets do not match: "expected: \"\$SSH_AUTH_SOCK\"   current: \"$SSH_AUTH_SOCK\""
    result=1
fi
exit \$result
COMPARE_ENV_STATE_SCRIPT
            fi
            if [ $? != 0 ] ; then return 1 ; fi
            # since it is correct, show the shell's environment
            env | grep SSH | sort
            echo Loaded identities:
            ssh-add -l
            ;;
        *) # for anything else, we assume that the user meant "add" with the provided parameters
            echo Agent proessing as \"add\" for \""$*"\"
            agent add "$@"
            ;;
    esac
}

# ensure that the agent info directory exists, otherwise the rest of this stuff may fail
if [ ! -d "${AGENT_INFO_DIR}" ] ; then mkdir "${AGENT_INFO_DIR}" ; fi
# detach from agent tracking when shell exists
trap "agent detach" EXIT
