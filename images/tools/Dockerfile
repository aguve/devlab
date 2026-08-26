FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    bash-completion \
    git \
    gh \
    curl \
    wget \
    nano \
    vim \
    less \
    tree \
    jq \
    zip \
    unzip \
    tar \
    rsync \
    openssh-client \
    ripgrep \
    fd-find \
    fzf \
    bat \
    htop \
    procps \
    dnsutils \
    iputils-ping \
    netcat-openbsd \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Alguns paquets tenen noms diferents a Debian
RUN ln -s /usr/bin/fdfind /usr/local/bin/fd && \
    ln -s /usr/bin/batcat /usr/local/bin/bat

WORKDIR /workspace

CMD ["tail", "-f", "/dev/null"]
