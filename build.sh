#!/bin/bash

SRC_DIR="$(readlink -m "$(pwd)")"
PKG_ROOT="$(dirname "${SRC_DIR}")"
DEBIAN_DIR="${PKG_ROOT}/DEBIAN"
BUILD_DIR="${PKG_ROOT}/build"

echo "PKG_ROOT='${PKG_ROOT}'"
echo "SRC_DIR='${SRC_DIR}'"
echo "DEBIAN_DIR='${DEBIAN_DIR}'"
echo "BUILD_DIR='${BUILD_DIR}'"

mkdir -p "${BUILD_DIR}" >&/dev/null

docker run \
    -i -t \
    --rm \
    -v ${SRC_DIR}:/pkgsrc:ro \
    -v ${DEBIAN_DIR}:/DEBIAN:ro \
    -v ${BUILD_DIR}:/deb \
    debasm $@

