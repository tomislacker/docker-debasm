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

#! install-container-source
ADD         assets/ /debasm

#! install-container-deps
RUN         /debasm/buildep.sh

#! startupmeta
ENTRYPOINT  /debasm/build.sh
CMD         [ ]

