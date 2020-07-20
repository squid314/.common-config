#!/usr/bin/bash

docker=docker
if [[ -e /var/run/docker.sock && ! -w /var/run/docker.sock ]] ; then
    docker='sudo docker'
fi

set -e
HOST_PWD="$PWD"

if [[ $1 = --name || $1 = -n ]] ; then
    container_name="--name ${2:?}"
    shift 2
fi

img=$USER.ide
if [[ $1 = --image || $1 = -i ]] ; then
    img=${2:?}
    shift 2
elif [[ -z "$($docker image ls | grep $img)" || $1 = --clean ]] ; then
    if [[ $1 = --clean ]] ; then shift ; fi
    $docker build -t $img \
        --pull \
        --build-arg USERID=$(id -u) \
        --build-arg USERNAME=$(id -un) \
        --build-arg GROUPID=$(id -g) \
        --build-arg GROUPNAME=$(id -gn) \
        --build-arg USERHOME="$HOME" \
        - <"$(dirname "$0")/Dockerfile"
fi

DOCKERGROUPID=$(stat -c %g /var/run/docker.sock)
run_user_dir="/run/user/`id -u`"
if [[ -d $run_user_dir ]] ; then
    mount_run_user_dir=-v\ "$run_user_dir:$run_user_dir"
fi

homeroot="$(dirname $HOME)"
exec $docker run \
    --rm \
    -i -t \
    $container_name \
    -v "/:/mnt/root" \
    -v "$homeroot:$homeroot" \
    $mount_run_user_dir \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --group-add $DOCKERGROUPID \
    -e HOST_PWD="$HOST_PWD" \
    -w "$HOST_PWD" \
    $img \
    "$@"

# vi: set ft=sh ts=4 sts=4 sw=4 et :
