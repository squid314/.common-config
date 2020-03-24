FROM registry.access.redhat.com/ubi8/ubi:latest

ENV HTTP_PROXY=http://deninfrap10:3128/ \
    HTTPS_PROXY=http://deninfrap10:3128/ \
    NO_PROXY=*.jeppesen.com,localhost
RUN set -ex ; \
    dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo ; \
    # quality of life: install man pages, please
    dnf config-manager --setopt=tsflags= --save ; \
    dnf makecache -y ; \
    dnf reinstall -y $(dnf list installed | sed 's/\..*//') ; \
    dnf update -y ; \
    dnf install -y \
        # common/important utilities
        git \
        vim-enhanced \
        bzip2 \
        file \
        openssl \
        diffutils \
        # base utilities not normally included in ubis, but make sense for a dev env
        procps-ng \
        sudo \
        # management
        docker-ce-cli \
        # quality of life
        unzip \
        man \
    ; \
    for i in ex {,r}vi{,ew} ; do \
        for j in vi vim ; do \
            alternatives --install /usr/local/bin/$i $i /usr/bin/$j ${#j} ; \
        done ; \
    done ; \
    dnf clean all ; \
    rm -rf /var/cache/dnf

CMD ["/bin/bash", "--login" ]

LABEL com.arisant.usage=development

ARG USERID
ARG USERNAME
ARG GROUPID
ARG GROUPNAME
ARG USERHOME
ENV \
    HOSTUSERID=$USERID \
    HOSTUSERNAME=$USERNAME \
    HOSTGROUPID=$GROUPID \
    HOSTGROUPNAME=$GROUPNAME \
    HOSTUSERHOME=$USERHOME

RUN mkdir -p $USERHOME ; \
    test -e /mnt && chmod -R 755 /mnt/ ; \
    if ! getent group $GROUPID ; then groupadd -og $GROUPID $GROUPNAME ; fi && \
    useradd -g $GROUPID -ou $USERID -Md $USERHOME $USERNAME
USER $USERNAME
WORKDIR /mnt/root/$USERHOME
