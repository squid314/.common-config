FROM registry.access.redhat.com/ubi8/ubi:latest

ENV HTTP_PROXY=http://deninfrap10:3128/ \
    HTTPS_PROXY=http://deninfrap10:3128/ \
    NO_PROXY=*.jeppesen.com,localhost
RUN set -ex ; \
    renice -n 19 $$ ; \
    subscription-manager register --org=3778237 --activationkey=jepppod ; \
    subscription-manager repos --enable=rhel-8-for-x86_64-baseos-rpms \
                               --enable=rhel-8-for-x86_64-appstream-rpms \
                               --enable=rhel-8-for-x86_64-supplementary-rpms ; \
    dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo ; \
    # quality of life: install man pages, please
    dnf config-manager --setopt=tsflags= --save ; \
    dnf update -y ; \
    dnf reinstall -y $(dnf list -q -y installed | sed -e 1d -e '/^ /d' -e 's/\..*//') ; \
    dnf install -y \
        # common/important utilities
        bash-completion \
        git \
        vim-enhanced \
        bzip2 \
        file \
        diffutils \
        # base utilities not normally included in ubis, but make sense for a dev env
        procps-ng \
        sudo \
        # management
        docker-ce-cli-18.09.* \
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
    rm -rf /var/cache/{yum,dnf} ; \
    subscription-manager unregister

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
