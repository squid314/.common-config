# jq.sh
# if jq is not available, but a container environment is, build a docker command

if type -P jq &>/dev/null ; then return ; fi

if type docker &>/dev/null ; then
    alias jq='docker run --rm --user $((10000 + $RANDOM % 10000)):$((10000 + $RANDOM % 10000)) -i --entrypoint=/bin/jq realguess/jq'
elif type podman &>/dev/null ; then
    alias jq='podman run --rm --user $((10000 + $RANDOM % 10000)):$((10000 + $RANDOM % 10000)) -i --entrypoint=/bin/jq realguess/jq'
fi
