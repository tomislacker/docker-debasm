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
    build-essential \
    curl \
    debhelper \
    devscripts \
    dh-make \
    dpkg-dev \
    fakeroot \
    gcc \
    git \
    patchutils \
    python-debian \
    unzip \
    vim \
    wget

#! install-container-source
ADD         assets/ /debasm

#! startupmeta
ENTRYPOINT  [ "/debasm/build.sh" ]
CMD [ ]
