FROM nvidia/cuda:11.1.1-cudnn8-runtime-ubuntu20.04

LABEL maintainer "Lucky-Mano <phatbowie@gmail.com>"

ENV PYTHON_VERSION=3.9.7 \
    WORKSPACE=/app

RUN apt-get update \
    && apt-get -y install \
        build-essential \
        zlib1g-dev \
        libncurses5-dev \
        libgdbm-dev \
        libnss3-dev \
        libssl-dev \
        libreadline-dev \
        libffi-dev \
        libsqlite3-dev \
        wget \
        libbz2-dev \
    && wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar -xf Python-${PYTHON_VERSION}.tgz \
    && rm Python-${PYTHON_VERSION}.tgz \
    && cd Python-${PYTHON_VERSION} \
    && ./configure --enable-optimizations \
    && make -j 12 \
    && make install \
    && cd / \
    && ln -s /usr/local/bin/python3 /usr/local/bin/python \
    && ln -s /usr/local/bin/pip3 /usr/local/bin/pip \
    && pip install -U --no-cache-dir pip setuptools poetry \
    && rm -rf /Python-${PYTHON_VERSION} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} docker \
    && useradd -u ${UID} -g ${GID} -s /bin/bash -m docker

USER ${UID}

WORKDIR ${WORKSPACE}

CMD ["sh", "run.sh"]