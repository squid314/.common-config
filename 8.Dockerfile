FROM registry.access.redhat.com/ubi8/ubi:latest AS builder

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
        diffutils \
        python2 \
        python38 \
        # base utilities not normally included in ubis, but make sense for a dev env
        procps-ng \
        sudo \
        # management
        docker-ce-cli-18.09.* \
        # quality of life
        unzip \
        man-db
RUN set -eux ; \
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
    dnf install -y $PACKAGES ; \
#    for pkg in $PACKAGES ; do \
#        rpm -q $pkg ; \
#    done ; \
    for i in ex {,r}vi{,ew} ; do \
        for j in vi vim ; do \
            alternatives --install /usr/local/bin/$i $i /usr/bin/$j ${#j} ; \
        done ; \
    done ; \
    alternatives --remove python /usr/libexec/no-python ; \
    dnf clean all ; \
    rm -rf /var/cache/{yum,dnf} ; \
    subscription-manager unregister

FROM scratch
COPY --from=builder / /

CMD ["/bin/bash", "--login" ]

LABEL com.arisant.usage=development

ARG USERID
ARG USERNAME
ARG GROUPID
ARG GROUPNAME
ARG USERHOME

RUN set -eux ; \
    mkdir -p $USERHOME ; \
    mkdir -p /mnt ; \
    chmod -R 755 /mnt ; \
    if ! getent group $GROUPID ; then groupadd -og $GROUPID $GROUPNAME ; fi && \
    useradd -g $GROUPID -ou $USERID -Md $USERHOME $USERNAME
USER $USERNAME
