#!/usr/bin/bash

if [[ $1 = --help ]] ; then
    printf '%s\n' \
        "$0 --help | --down [-f|--force] [--name name] | [--clean] [--name name] [cmd args...]" \
        "" \
        "    --help      show help" \
        "    --down      shut down the live dev container" \
        "    --force|-f  shut down forcing existing processes to exit" \
        "    --clean     request a new build and tag of the image. useful to ensure up-to-date packages" \
        "    --name      provide a specific container name. can be used to manage multiple independent containers" \
        "" \
        "    cmd args... If provided, will be executed as the entry command inside the" \
        "                container, using the current directory as the workdir of the" \
        "                command. If no command is provided, the default command of the" \
        "                image is used (probably a shell)." \
        >&2
    exit
fi

docker=docker
if [[ -e /var/run/docker.sock && ! -w /var/run/docker.sock ]] ; then
    docker='sudo docker'
fi

set -e
HOST_PWD="$PWD"

img="$(whoami).ide"
if [[ -z "$($docker image ls -q $img)" || $1 = --clean ]] ; then
    if [[ $1 = --clean ]] ; then
        shift
        container_id="$($docker container ls -q --filter=ancestor=$img | head -n 1)"
        if [[ -n "$container_id" ]] ; then
            printf '%s\n' \
                "\e[0;1;31m##### Warning: leaving dangling container: $container_id\e[0m"
                >&2
        fi
    fi
    $docker build --tag $img \
        --pull \
        --build-arg USERID=$(id -u) \
        --build-arg USERNAME=$(id -un) \
        --build-arg GROUPID=$(id -g) \
        --build-arg GROUPNAME=$(id -gn) \
        --build-arg USERHOME="$HOME" \
        - <"$(dirname "$0")/Dockerfile"
fi

container_id="$($docker container ls -q --filter=ancestor=$img | head -n 1)"
if [[ $1 = --name ]] ; then
    container_name="$2"
    shift 2
    container_id="$($docker container ls -q --filter=name=$container_name"$")"
fi

if [[ $1 = --down ]] ; then
    if [[ -n "$container_id" ]] ; then
        pids=$($docker exec "$container_id" ps h -ef | wc -l)
        if [[ $pids -le 2 || $2 = -f || $2 = --force ]] ; then
            $docker kill "$container_id" >/dev/null
        else
            echo "$0: error: cannot shut down, running processes exist" >&2
            exit 1
        fi
    fi
    exit
elif [[ -z "$container_id" ]] ; then
    DOCKERGROUPID="$(stat -c %g /var/run/docker.sock)"
    run_user_dir="/run/user/$(id -u)"
    if [[ -d $run_user_dir ]] ; then
        mount_run_user_dir=--mount\ "type=bind,src=$run_user_dir,dst=$run_user_dir"
    fi

    homeroot="$(dirname $HOME)"
    container_id="$(
    $docker run \
        --rm \
        --detach \
        --interactive --tty \
        ${container_name:+--name $container_name} \
        --mount "type=bind,src=/,dst=/mnt/root" \
        --mount "type=bind,src=$homeroot,dst=$homeroot" \
        $mount_run_user_dir \
        --mount "type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock" \
        --group-add $DOCKERGROUPID \
        --workdir "$HOME" \
        $img
    )"
fi

if [[ $# -eq 0 ]] ; then
    eval set -- $($docker image inspect $img --format '{{range $i,$e := .Config.Cmd}}{{if $i}} {{end}}"{{$e}}"{{end}}')
fi
exec $docker exec \
    --interactive --tty \
    --env HOST_PWD="$HOST_PWD" \
    --workdir "$HOST_PWD" \
    "$container_id" \
    "${@}"

# vi: set ft=sh ts=4 sts=4 sw=4 et :
