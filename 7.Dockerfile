FROM registry.access.redhat.com/rhel7:latest

ENV http_proxy=http://deninfrap10:3128/ https_proxy=http://deninfrap10:3128/
RUN printf '[jeppden]\nname=jeppden\nbaseurl=https://denpach02d.jeppesen.com\ngpgcheck=0\nenabled=1\nsslverify=0\n' >/etc/yum.repos.d/jeppden.repo
RUN curl -so /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo
RUN \
    # quality of life: install man pages, please
    yum-config-manager --setopt=tsflags= --save && \
    yum update -y && \
    yum install -y \
        # common/important utilities
        git \
        emacs \
        vim \
        bzip2 \
        # management
        docker-ce-cli \
        # quality of life
        unzip \
        man \
    && \
    yum clean all

CMD ["/bin/bash", "--login" ]

LABEL com.arisant.usage=development

ARG DOCKERGROUPID
ENV DOCKERGROUPID=$DOCKERGROUPID
RUN if ! getent group $DOCKERGROUPID ; then groupadd -g $DOCKERGROUPID dockerindocker ; fi

ARG USERID
ARG USERNAME
ARG GROUPID
ARG GROUPNAME
ARG USERHOME
ENV HOSTUSERNAME=$USERNAME HOSTUSERID=$USERID HOSTGROUPID=$GROUPID HOSTUSERHOME=$USERHOME HOSTGROUPNAME=$GROUPNAME

RUN mkdir -p $USERHOME ; \
    test -e /mnt && chmod -R 755 /mnt/ ; \
    if ! getent group $GROUPID ; then groupadd -g $GROUPID $GROUPNAME ; fi && \
    useradd -g $GROUPNAME -G $DOCKERGROUPID -u $USERID -Md $USERHOME $USERNAME
USER $USERNAME
WORKDIR /mnt/root/$USERHOME
