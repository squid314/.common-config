#FROM registry.access.redhat.com/rhel7:latest
FROM registry.access.redhat.com/ubi7/ubi:latest

ENV http_proxy=http://deninfrap10:3128/ https_proxy=http://deninfrap10:3128/
#RUN printf '[jeppden]\nname=jeppden\nbaseurl=https://denpach02d.jeppesen.com\ngpgcheck=0\nenabled=1\nsslverify=0\n' >/etc/yum.repos.d/jeppden.repo
RUN curl -so /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo
RUN \
    # quality of life: install man pages, please
    yum-config-manager --setopt=tsflags= --save && \
    yum update -y && \
    yum install -y \
        # common/important utilities
        git \
        emacs \
        vim-enhanced \
        bzip2 \
        file \
        openssl \
        # management
        docker-ce-cli \
        # quality of life
        unzip \
        man \
    && \
    yum clean all && \
    # why vim-enhanced doesn't overwrite the utils installed by vim-minimal, idk
    ln -fs vim /usr/bin/vi

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
