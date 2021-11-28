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
        gnupg2 \
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
    VERSION_CODENAME=$(cat /etc/os-release | grep VERSION_CODENAME | awk -F= {' print $2'}) && \
    echo "deb http://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME}-12 main" >> /etc/apt/sources.list && \
    echo "deb-src http://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME}-12 main" >> /etc/apt/sources.list && \
    curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get update -y && \
    apt-get install -y \
        clang-12 \
        lld-12 \
        lldb-12 \
        llvm-12-dev \
        nodejs \
        && \
    apt-get autoclean && \
    update-alternatives --install /usr/bin/cc cc /usr/lib/llvm-12/bin/clang 100 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/lib/llvm-12/bin/clang++ 100 && \
    useradd user -m -s /bin/bash && \
    mkdir -p /opt/workspace && \
    chown user:user /opt/workspace && \
    chmod u+w /etc/sudoers && \
    echo 'user    ALL=(ALL)    NOPASSWD:ALL' > /etc/sudoers && \
    chmod u-w /etc/sudoers

ENV PATH=$PATH:/usr/lib/llvm-12/bin \
    PROJECT_PATH= \
    RUN_CMD= \
    INIT_FILE= \
    WAIT_SEC=0 \
    WAIT_HOST= \
    WAIT_PORT=

USER user

VOLUME [ "/home/user" ]

WORKDIR /opt/workspace

CMD sh /opt/wait_to_run.sh /opt/workspace/${PROJECT_PATH} ${WAIT_SEC} ${WAIT_HOST} ${WAIT_PORT}
