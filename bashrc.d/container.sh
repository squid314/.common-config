# container management tools

if type docker &>/dev/null ; then
    alias d=docker
    if [[ -e /var/run/docker.sock && ! -w /var/run/docker.sock ]] ; then
        alias docker='sudo docker'
    fi
fi

if type podman &>/dev/null ; then
    alias p=podman
    if type buildah &>/dev/null ; then
        alias b=buildah
    fi
fi
