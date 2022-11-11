# contained.sh
# some commands are annoying to install, but can be provided by a container env. create aliases if the core command isn't present but container runtimes are

if ! type docker &>/dev/null && !type podman &>/dev/null ; then return ; fi

# make sure to add all aspects of the command which are needed, like entrypoint overriding
declare -A __contained_commands
__contained_commands=(
    [jq]="--entrypoint=/bin/jq realguess/jq"
    [yq]="mikefarah/yq"
)

for c in "${!__contained_commands[@]}" ; do
    if type -P "$c" &>/dev/null ; then continue ; fi

    if type docker &>/dev/null ; then
        alias "$c"="docker run --rm --user $((10000 + $RANDOM % 10000)):$((10000 + $RANDOM % 10000)) -i ${__contained_commands[$c]}"
    elif type podman &>/dev/null ; then
        alias "$c"="podman run --rm --user $((10000 + $RANDOM % 10000)):$((10000 + $RANDOM % 10000)) -i ${__contained_commands[$c]}"
    fi
done
