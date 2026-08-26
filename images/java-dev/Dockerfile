FROM eclipse-temurin:${JAVA_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    nano \
    vim \
    less \
    tree \
    zip \
    unzip \
    bash-completion \
    procps \
    iputils-ping \
    dnsutils \
    openssh-client \
    maven \
    gradle \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

CMD ["tail", "-f", "/dev/null"]
