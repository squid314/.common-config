#!/bin/bash

set -e
HOST_PWD="$PWD"
cd $(dirname $0)

if [[ $# -gt 1 && "x$1" = "x-n" ]] ; then
    shift
    container_name="--name $1"
    shift
fi

if [[ -z "$(docker image ls | grep $USER.ide)" || "$1" == "-clean" ]]; then
    if [[ "$1" == "-clean" ]] ; then
        shift
    fi
    docker build -t $USER.ide \
        --build-arg USERID=$(id -u $USER) \
        --build-arg USERNAME=$USER \
        --build-arg GROUPNAME=$(id -gn $USER) \
        --build-arg GROUPID=$(id -g $USER) \
        --build-arg USERHOME=$HOME \
        .
fi

homeroot="$(dirname $HOME)"
exec docker run -it \
    --rm \
    $container_name \
    -v "/:/mnt/root" \
    -v "$homeroot:$homeroot" \
    -e HOST_PWD="$HOST_PWD" \
    -w "$HOST_PWD" \
    $USER.ide \
    "$@"

# vi: set ft=sh ts=4 sts=4 sw=4 et :
