#!/bin/bash

export DEFAULT_ISO_8601=seconds

export DEBASM_INCL_CANONICAL="$(readlink -m "${BASH_SOURCE}")"
export DEBASM_ROOT="$(dirname "${DEBASM_INCL_CANONICAL}")"

export DEBASM_BUILDEPS=( \
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
    wget \
)

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

