# contained.sh
# some commands are annoying to install, but can be provided by a container env. create aliases if the core command isn't present but container runtimes are

if ! type docker &>/dev/null && !type podman &>/dev/null ; then return ; fi

# make sure to add all aspects of the command which are needed, like entrypoint overriding
commands=(
    jq="--entrypoint=/bin/jq     realguess/jq"
    yq="--entrypoint=/usr/bin/yq mikefarah/yq"
    bat="-t quay.io/squid314/devenv:bat"
)

for c in "${!commands[@]}" ; do
    if type -P "$c" &>/dev/null ; then continue ; fi

    if type docker &>/dev/null ; then
        alias "$c"="docker run --rm --user $((10000 + $RANDOM % 10000)):$((10000 + $RANDOM % 10000)) -i ${commands[$c]}"
    elif type podman &>/dev/null ; then
        alias "$c"="podman run --rm --user $((10000 + $RANDOM % 10000)):$((10000 + $RANDOM % 10000)) -i ${commands[$c]}"
    fi
done
