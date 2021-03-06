#! meta
FROM        debian:wheezy
MAINTAINER  asdf234

#! volume
RUN         mkdir -p /deb /pkgsrc /DEBIAN
VOLUME      /pkgsrc
VOLUME      /deb
VOLUME      /DEBIAN

#! refresh
RUN         apt-get update

#! install-container-deps
RUN         apt-get install -qq --no-install-recommends \
    automake \
    bison \
    build-essential \
    curl \
    debhelper \
    devscripts \
    dh-make \
    dpkg-dev \
    fakeroot \
    flex \
    gcc \
    git \
    patchutils \
    python-debian \
    unzip \
    vim \
    wget

###
# Qt Libraries Required
###
RUN         apt-get install -qq --no-install-recommends \
    libqt4-core \
    libqt4-dbus \
    libqt4-dev \
    libqt4-network \
    libqt4-sql-mysql \
    libqt4-xml \
    libqtglib-2.0-0 \
    libqxmlrpc-dev

###
# SOAP Libraries Required
###
RUN         apt-get install -qq --no-install-recommends \
    gsoap

###
# Add libraries for performing 32bit/multilib builds
###
RUN         apt-get install -qq --no-install-recommends \
    gcc-multilib \
    libc6-dev-i386

#! install-container-source
ADD         assets/ /debasm

#! startupmeta
ENTRYPOINT  [ "/debasm/build.sh" ]
CMD [ ]
