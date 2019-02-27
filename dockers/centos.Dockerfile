FROM centos

RUN set -e; \
    yum update -y; \
    yum install -y \
        sudo \
        git \
        vim \
        curl \
        bzip2 \
		docker-client \
    ; \
    for i in ex {,r}vi{,ew} ; do \
        for j in vi vim ; do \
            alternatives --install /usr/local/bin/$i $i /usr/bin/$j ${#j}; \
        done; \
    done; \
    yum clean all

RUN set -e; \
    useradd -mU -s /bin/bash squid; \
    # TODO need this or not?
    echo 'squid   ALL=NOPASSWD:(ALL:ALL) ALL' >>/etc/sudoers.d/no-passwd-sudo

USER squid
WORKDIR /home/squid

RUN set -e; \
    curl -so /tmp/setup.sh https://raw.githubusercontent.com/squid314/.common-config/master/bin/setup.sh; \
    bash /tmp/setup.sh no-agent; \
    rm /tmp/setup.sh

CMD ["/bin/bash", "-il"]
