#!/bin/bash

###########################
# /debasm/build.sh #
################################################################################
#
# ## Usage
# ***@TODO***
#
# ## Exit Values
# ***@TODO***
################################################################################

# First, ensure we can access some common libraries
if ! . "$(dirname ${BASH_SOURCE})/debasm.inc.sh"; then
    echo "FATAL: Cannot include debasm.inc.sh -> ''" >&2
    exit 254
fi

PKG_NAME=
PKG_VER=
PKG_DEBVER=
PKG_FULLVER=
PKG_DEBNAME=
PKG_USER_EMAIL=
USER=$(whoami)
LOGNAME=$(whoami)

while getopts ":n:v:r:d:e:" OPT; do
    case $OPT in
        n)  PKG_NAME="$OPTARG" ;;
        v)  PKG_VER="$OPTARG" ;;
        r)  PKG_DEBVER="$OPTARG" ;;
        d)  PKG_DEBNAME="$OPTARG" ;;
        e)  PKG_USER_EMAIL="$OPTARG" ;;
        U)  USER="$OPTARG" ;;
        L)  LOGNAME="$OPTARG" ;;
        ?)
            echo "ERROR: Invalid option -${OPTARG}" >&2
            exit 1
            ;;
        \*)
            echo "ERROR: Option -${OPTARG} requires argument" >&2
            exit 1
            ;;
    esac
done

if [ -z "$PKG_NAME" ]; then
    echo "ERROR: No package name (-n) provided" >&2
    exit 1
elif [ -z "$PKG_VER" ]; then
    echo "ERROR: No package version (-v) provided" >&2
    exit 1
fi

if [ -z "$PKG_DEBNAME" ]; then
    PKG_DEBNAME="${PKG_NAME}-${PKG_VER}"
    if [ -n "${PKG_DEBVER}" ]; then
        PKG_DEBNAME="${PKG_DEBNAME}-${PKG_DEBVER}"
    fi
fi

PKG_FULLVER="${PKG_VER}"
if [ -n "${PKG_DEBVER}" ]; then
    PKG_FULLVER="${PKG_FULLVER}-${PKG_DEBVER}"
fi

dumpVariables.prePkgBuild

# Determine where the package will be assembled
log.notice "Copying pkgsrc '${PKG_SOURCE_DIR}' -> '${PKG_TEMP_DIR}'"
mkdir -p "${PKG_TEMP_DIR}"
cp -r ${PKG_SOURCE_DIR}/* ${PKG_TEMP_DIR}/ \
    || exit $?

if [ -d "${PKG_TEMP_DIR}/DEBIAN" ]; then
    log.debug "Cleaning out ${PKG_TEMP_DIR}/DEBIAN"
    rm -fr ${PKG_TEMP_DIR}/DEBIAN >&/dev/null
fi

log.notice "Copying DEBIAN '${PKG_DEBIAN_DIR}' -> '${PKG_TEMP_DIR}'"
cp -r ${PKG_DEBIAN_DIR} ${PKG_TEMP_DIR}/ \
    || exit $?

cd "${PKG_TEMP_DIR}"

log.notice "Doing control modifications..."
sed -i "s/^Package:.*$/Package: ${PKG_NAME}/g" DEBIAN/control
sed -i "s/^Version:.*$/Version: ${PKG_FULLVER}/g" DEBIAN/control

log.notice "Starting dpkg-deb (pwd='$(pwd)')"
dpkgDebArgs=( \
    --build \
    ./ \
    /deb/${PKG_DEBNAME}.deb \
)
log.debug "\tdpkg-deb ${dpkgDebArgs[*]}"
dpkg-deb ${dpkgDebArgs[*]} >&/dev/null
dpkgDebExit=$?

if [[ $dpkgDebExit -ne 0 ]]; then
    log.crit "\tdpkg-deb FAILED"
    exit 100
else
    log.notice "\tdpkg-deb complete"
fi

