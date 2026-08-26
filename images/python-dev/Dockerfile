FROM python:${PYTHON_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

# Actualització i eines de desenvolupament
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    nano \
    vim \
    tree \
    less \
    zip \
    unzip \
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    pkg-config \
    bash-completion \
    && rm -rf /var/lib/apt/lists/*

# Python modern
RUN python -m pip install --upgrade \
    pip \
    setuptools \
    wheel \
    pipx

# Llibreries habituals
RUN pip install \
    numpy \
    pandas \
    matplotlib \
    scikit-learn \
    opencv-python-headless \
    pillow \
    requests \
    flask \
    fastapi \
    uvicorn \
    pytest \
    black \
    ruff \
    mypy \
    jupyterlab \
    ipython
    
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /workspace

CMD ["tail", "-f", "/dev/null"]
