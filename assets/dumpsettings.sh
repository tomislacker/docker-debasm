#!/bin/bash

# /debasm/dumpsettings.sh

getVariableValueByName ()
{
    local variableName=$1
    eval "echo \$${variableName}"
}

###
# Define an array of variable names that will be dumped if none are specified
# via the command line
###
DEFAULT_SETTING_NAMES=( \
    PKG_NAME \
    PKG_VER \
    PKG_DEBVER \
    PKG_USER_EMAIL \
    USER \
    LOGNAME \
    PKG_TEMP_DIR
)

###
# Read the command line arguments to determine if we're going to either:
# 1) [if $# -eq 0] SETTING_NAMES = $DEFAULT_SETTING_NAMES
# 2) [elif $1 -eq _ ] SETTING_NAMES += $@
# 3) [else $# -gt 0 ] SETTING_NAMES = $@
###

# Set default mode
SETTING_NAMES_MODE=default

if [[ $# -gt 1 ]]; then
    if [ "$1" == '-' ]; then
        SETTING_NAMES_MODE=replace
        shift
    else
        SETTING_NAMES_MODE=append
    fi
fi

# Based on the SETTING_NAMES_MODE , load up the array of SETTING_NAMES
case $SETTING_NAMES_MODE in
    append|default)
        SETTING_NAMES=( ${DEFAULT_SETTING_NAMES[*]} $@ )
        ;;
    replace)
        SETTING_NAMES=( $@ )
        ;;
    *)
        echo "ERROR: Invalid SETTING_NAMES_MODE='${SETTING_NAMES_MODE}'" >&2
        exit 1
        ;;
esac

# Loop through each of the SETTING_NAMES and output that variable
for settingName in ${SETTING_NAMES[*]}; do
    echo -e "${settingName}:\t'$(getVariableValueByName ${settingName})'"
done

