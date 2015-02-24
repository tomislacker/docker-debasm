#! meta
FROM        debian:wheezy
MAINTAINER  asdf234

#! volume
VOLUME      /pkgsrc

#! refresh
RUN         apt-get update

#! install
RUN         apt-get install -qq --no-install-recommends \
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

#! settings
ENV         PKG_NAME=dockerrootfs
ENV         PKG_VER=1.0
ENV         PKG_DEBVER=1
ENV         PKG_USER_EMAIL=asdf@234.com

ENV         USER=root
ENV         LOGNAME=${USER}
ENV         PKG_TEMP_DIR="/${PKG_NAME}-${PKG_VER}-${PKG_DEBVER}"

ENV         DEBASM_DUMPSETTINGS=y
ENV         DEBASM_DUMPSETTINGS_PADLINES=y

#! install-container-source
ADD         assets/ /debasm

#! startupmeta
ENTRYPOINT  /debasm/build.sh
CMD         [ ]

