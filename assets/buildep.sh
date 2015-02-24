#!/bin/bash

###########################
# /debasm/buildep.sh #
################################################################################
#
# ## Usage
# ***@TODO***
#
# ## Exit Values
# ***@TODO***
################################################################################

# First, ensure we can access some common libraries
log.debug "buildep.sh is @deprecated"
exit 0

if ! . "$(dirname ${BASH_SOURCE})/debasm.inc.sh"; then
    echo "FATAL: Cannot include debasm.inc.sh -> ''" >&2
    exit 254
fi

log.notice "Installing ${#DEBASM_BUILDEPS[*]} dependencies..."
apt-get install \
    -qq \
    --no-install-recommends \
    ${DEBASM_BUILDEPS[*]} \
    2>>/dev/null \
    >>/dev/null
log.notice "Dependency installation complete"
