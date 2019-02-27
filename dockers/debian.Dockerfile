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
    echo 'squid   ALL=NOPASSWD:(ALL:ALL) ALL' >>/etc/sudoers.d/no-passwd-sudo

USER squid

RUN curl -vs https://raw.githubusercontent.com/squid314/.common-config/raw/master/bin/setup.sh | bash -s - no-agent

CMD ["/bin/bash"]
