FROM ubuntu

LABEL maintainer="Andy Deng <andy.z.deng@gmail.com>"

COPY wait_to_run.sh /opt

RUN chmod 644 /opt/wait_to_run.sh && \
    apt-get update -y && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" \
    apt-get install -y \
        bison \
        build-essential \
        cmake \
        curl \
        flex \
        git \
        libncurses5 \
        lsof \
        netcat \
        net-tools \
        psmisc \
        python3 \
        sudo \
        telnet \
        vim \
        xz-utils \
        && \
    apt-get autoclean && \
    useradd user -m -s /bin/bash && \
    mkdir -p /opt/workspace && \
    chown user:user /opt/workspace && \
    chmod u+w /etc/sudoers && \
    echo 'user    ALL=(ALL)    NOPASSWD:ALL' > /etc/sudoers && \
    chmod u-w /etc/sudoers

ENV PROJECT_PATH='project_not_exist' \
    RUN_CMD= \
    INIT_FILE= \
    WAIT_SEC=0 \
    WAIT_HOST= \
    WAIT_PORT=

USER user

VOLUME [ "/home/user" ]

WORKDIR /opt/workspace

CMD sh /opt/wait_to_run.sh /opt/workspace ${PROJECT_PATH} ${WAIT_SEC} ${WAIT_HOST} ${WAIT_PORT}
