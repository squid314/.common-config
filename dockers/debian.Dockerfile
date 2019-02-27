FROM debian

RUN set -e; \
    apt-get update; \
    apt-get install -y \
        sudo git vim curl bzip2 \
    ; \
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
