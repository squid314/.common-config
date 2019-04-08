FROM debian

RUN set -e; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y \
        sudo \
        git \
        vim \
        curl \
        bzip2 \
        apt-transport-https \
        ca-certificates \
        gnupg2 \
        software-properties-common \
    ; \
    curl -fsSLo /tmp/gpg https://download.docker.com/linux/debian/gpg; \
    apt-key add /tmp/gpg; \
    rm /tmp/gpg; \
    \
    # dependencies for building git
    apt-get install -y \
        dh-autoreconf \
        libcurl4-gnutls-dev \
        libexpat1-dev \
        gettext \
        libz-dev \
        libssl-dev \
        asciidoc \
        xmlto \
        docbook2x \
        install-info\
    ; \
    git clone --depth 30 https://github.com/git/git.git /tmp/git; \
    cd /tmp/git; \
    git checkout $(git log --simplify-by-decoration --decorate --oneline origin/master | sed -n "/tag: v[0-9.]*[),]/{s/.*tag: \\(v[^),]*\\).*/\\1/;p;q}"); \
    make configure; \
    ./configure --prefix=/usr; \
    make all doc info; \
    make install install-doc install-html install-info; \
    cd /; rm -rf /tmp/git; \
    \
    rm -rf /var/lib/apt/lists/*

RUN set -e; \
    useradd -mU -s /bin/bash squid; \
    # TODO need this or not?
    echo 'squid   ALL=(ALL:ALL) NOPASSWD: ALL' >>/etc/sudoers.d/no-passwd-sudo

USER squid
WORKDIR /home/squid

RUN set -e; \
    curl -so /tmp/setup.sh https://raw.githubusercontent.com/squid314/.common-config/master/bin/setup.sh; \
    bash /tmp/setup.sh no-agent; \
    rm /tmp/setup.sh

CMD ["/bin/bash", "-il"]
