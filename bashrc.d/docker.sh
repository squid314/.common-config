# docker tools

if ! type docker &>/dev/null ; then
    return
fi


alias d=docker

if [[ -e /var/run/docker.sock && ! -w /var/run/docker.sock ]] ; then
    alias docker='sudo docker'
fi
