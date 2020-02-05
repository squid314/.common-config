#FROM registry.access.redhat.com/rhel7:latest
FROM registry.access.redhat.com/ubi7/ubi:latest

ENV http_proxy=http://deninfrap10:3128/ https_proxy=http://deninfrap10:3128/
#RUN printf '[jeppden]\nname=jeppden\nbaseurl=https://denpach02d.jeppesen.com\ngpgcheck=0\nenabled=1\nsslverify=0\n' >/etc/yum.repos.d/jeppden.repo
RUN curl -so /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo
RUN set -ex ; \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo ; \
    yum-config-manager --add-repo https://gist.githubusercontent.com/squid314/97f3d4d863729d5093e9ebbc00545aa6/raw/d7a95d8b663a3168aa1fadaf1fab1ab538f5fb47/kubernetes.repo ; \
    # quality of life: install man pages, please
    yum-config-manager --setopt=tsflags= --save ; \
    yum reinstall -y $(yum list installed | sed '/^ /d;s/\..*//') ; \
    yum update -y ; \
    yum install -y \
        # common/important utilities
        git \
        emacs \
        vim-enhanced \
        bzip2 \
        file \
        openssl \
        sudo \
        # management
        docker-ce-cli \
        kubectl \
        # quality of life
        unzip \
        man \
    ; \
    for i in ex {,r}vi{,ew} ; do \
        for j in vi vim ; do \
            alternatives --install /usr/local/bin/$i $i /usr/bin/$j ${#j} ; \
        done ; \
    done ; \
    yum clean all ; \
    rm -rf /var/cache/yum

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
