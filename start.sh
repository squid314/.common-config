#!/bin/bash

if [[ -e /var/run/docker.sock && ! -w /var/run/docker.sock ]] ; then
    docker() { sudo docker "$@" ; }
fi

set -e
HOST_PWD="$PWD"


if [[ $# -gt 1 && "x$1" = "x-n" ]] ; then
    shift
    container_name="--name $1"
    shift
fi

DOCKERGROUPID=$(stat -c %g /var/run/docker.sock)
if [[ -z "$(docker image ls | grep $USER.ide)" || "$1" == "-clean" ]]; then
    if [[ "$1" == "-clean" ]] ; then shift ; fi
    docker build -t $USER.ide \
        --build-arg USERID=$(id -u) \
        --build-arg USERNAME=$(id -un) \
        --build-arg GROUPID=$(id -g) \
        --build-arg GROUPNAME=$(id -gn) \
        --build-arg USERHOME="$HOME" \
        - <"$(dirname "$0")/Dockerfile"
fi

homeroot="$(dirname $HOME)"
docker run \
    --rm \
    -i -t \
    $container_name \
    -v "/:/mnt/root" \
    -v "$homeroot:$homeroot" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --group-add $DOCKERGROUPID \
    -e HOST_PWD="$HOST_PWD" \
    -w "$HOST_PWD" \
    $USER.ide \
    "$@"

# vi: set ft=sh ts=4 sts=4 sw=4 et :
