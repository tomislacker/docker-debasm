#!/bin/bash

export DEFAULT_ISO_8601=seconds

export DEBASM_INCL_CANONICAL="$(readlink -m "${BASH_SOURCE}")"
export DEBASM_ROOT="$(dirname "${DEBASM_INCL_CANONICAL}")"

export PKG_SOURCE_DIR="/pkgsrc"
export PKG_TEMP_DIR="/pkgdst"
export PKG_DEBIAN_DIR="/DEBIAN"

if [ -z "$PKG_DEBNAME" ]; then
    PKG_DEBNAME="${PKG_NAME}-${PKG_VER}-${PKG_DEBVER}"
fi


if ! . "${DEBASM_ROOT}/debasm_log.inc.sh" 2>>/dev/null ; then
    echo -e "FATAL:\tCannot include debasm_log.inc.sh" >&2
    exit 254
fi

getVariableValueByName ()
{
    local variableName=$1
    eval "echo \$${variableName}"
}

dumpVariables ()
{
    if [[ $# -eq 0 ]]; then
        log.err "Cannot call dumpVariables()..."
        return 1
    fi
    
    while [ -n "$1" ]; do
        log.debug "${1}:\t$(getVariableValueByName "${1}")"
        shift
    done
}

dumpVariables.prePkgBuild ()
{
    log.debug ':: dumpVariables.prePkgBuild() ::'
    dumpVariables PKG_NAME \
        PKG_VER \
        PKG_DEBVER \
        PKG_USER_EMAIL \
        USER \
        LOGNAME \
        PKG_TEMP_DIR \
        $@
}

