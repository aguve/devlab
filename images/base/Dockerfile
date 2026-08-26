FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Barcelona

ARG USERNAME=developer
ARG UID=1000
ARG GID=1000

RUN apt-get update && apt-get install -y \
    bash \
    bash-completion \
    sudo \
    git \
    curl \
    wget \
    nano \
    vim \
    less \
    tree \
    zip \
    unzip \
    procps \
    iputils-ping \
    dnsutils \
    openssh-client \
    ca-certificates \
    locales \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Locale UTF-8
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Crear grup i usuari igual que al host
RUN groupadd -g ${GID} ${USERNAME} && \
    useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /workspace

USER ${USERNAME}

CMD ["tail", "-f", "/dev/null"]
