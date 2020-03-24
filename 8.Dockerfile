FROM registry.access.redhat.com/rhel7:latest

ENV HTTP_PROXY=http://deninfrap10:3128/ \
    HTTPS_PROXY=http://deninfrap10:3128/ \
    NO_PROXY=*.jeppesen.com,localhost
RUN printf '%s\n' '[jeppden]' 'name=jeppden' 'baseurl=https://denpach02d.jeppesen.com' '        https://denpach02d' 'gpgcheck=0' 'enabled=1' 'sslverify=0' >/etc/yum.repos.d/jeppden.repo
RUN set -ex ; \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo ; \
    # quality of life: install man pages, please
    yum-config-manager --setopt=tsflags= --save ; \
    yum makecache -y ; \
    yum reinstall -y $(yum list installed | sed 's/\..*//') ; \
    yum update -y ; \
    yum install -y \
        # common/important utilities
        git \
        vim-enhanced \
        bzip2 \
        file \
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
