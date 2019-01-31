FROM registry.access.redhat.com/rhel7:latest

RUN printf '[jeppden]\nname=jeppden\nbaseurl=https://denpach02d.jeppesen.com\ngpgcheck=0\nenabled=1\nsslverify=0\n' >/etc/yum.repos.d/jeppden.repo
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
        docker-client \
        # quality of life
        unzip \
        man \
    && \
    yum clean all

CMD ["/bin/bash", "--login" ]

LABEL com.arisant.usage=development

ARG USERID
ARG USERNAME
ARG GROUPID
ARG GROUPNAME
ARG USERHOME
ENV HOSTUSERNAME=$USERNAME HOSTUSERID=$USERID HOSTGROUPID=$GROUPID HOSTUSERHOME=$USERHOME HOSTGROUPNAME=$GROUPNAME

RUN mkdir -p $USERHOME ; \
    test -e /mnt && chmod -R 755 /mnt/ ; \
    groupadd -g $GROUPID $GROUPNAME && \
    useradd -g $GROUPNAME -u $USERID -Md $USERHOME $USERNAME
USER $USERNAME
WORKDIR /mnt/root/$USERHOME
