#! meta
FROM        debian:wheezy
MAINTAINER  asdf234

#! volume
VOLUME      /pkgsrc

#! refresh
RUN         apt-get update

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

#! install-container-deps
RUN         /debasm/buildep.sh

#! settings2
#ENV         PKG_FORMAT=1.0
#ENV         PKG_NODEFAULTS=y

#! startupmeta
ENTRYPOINT  /debasm/build.sh
CMD         [ ]

