FROM registry.access.redhat.com/ubi7/ubi:latest

ENV HTTP_PROXY=http://deninfrap10:3128/ \
    HTTPS_PROXY=http://deninfrap10:3128/ \
    NO_PROXY=jeppesen.com,localhost,127.0.0.1,localhost6,::1 \
    http_proxy=http://deninfrap10:3128/ \
    https_proxy=http://deninfrap10:3128/ \
    no_proxy=jeppesen.com,localhost,127.0.0.1,localhost6,::1
ENV PACKAGES \
        # common/important utilities
        bash-completion \
        git \
        rsync \
        vim-enhanced \
        bzip2 \
        file \
        openssl \
        python \
        python27 \
        python3 \
        sudo \
        # management
        docker-ce-cli-18.09.* \
        # quality of life
        unzip \
        man-db
RUN set -eux ; \
    renice -n 19 $$ ; \
    subscription-manager register --org=3778237 --activationkey=jepppod ; \
    subscription-manager repos --enable=rhel-7-server-rpms \
                               --enable=rhel-7-server-extras-rpms \
                               --enable=rhel-7-server-optional-rpms \
                               --enable=rhel-7-server-supplementary-rpms ; \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo ; \
    # quality of life: install man pages, please
    yum-config-manager --setopt=tsflags= --save ; \
    yum reinstall -y $(yum list -q -y installed | sed -e 1d -e '/^ /d' -e 's/\..*//') ; \
    yum update -y ; \
    yum install -y $PACKAGES ; \
    for pkg in $PACKAGES ; do \
        rpm -q $pkg ; \
    done ; \
    for i in ex {,r}vi{,ew} ; do \
        for j in vi vim ; do \
            alternatives --install /usr/local/bin/$i $i /usr/bin/$j ${#j} ; \
        done ; \
    done ; \
    alternatives --install /usr/bin/python2 python2 /usr/bin/python2.7 2 ; \
    alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 3 ; \
    alternatives --install /usr/bin/python python /usr/bin/python2 2 ; \
    alternatives --install /usr/bin/python python /usr/bin/python3 3 ; \
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

RUN set -eux ; \
    mkdir -p $USERHOME ; \
    mkdir -p /mnt ; \
    chmod -R 755 /mnt/ ; \
    if ! getent group $GROUPID ; then groupadd -og $GROUPID $GROUPNAME ; fi && \
    useradd -g $GROUPID -ou $USERID -Md $USERHOME $USERNAME
USER $USERNAME
WORKDIR /mnt/root/$USERHOME
