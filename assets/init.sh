!/bin/bash

###########################
# /debasm/init.sh #
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

cd ${PKG_SOURCE_DIR}

DH_MAKE_ARGS=( \
    --native \
    --single \
    --email default@noemail.com \
    --yes \
    --indep \
)

if [ -d DEBIAN ]; then
    DH_MAKE_ARGS+=( \
        --addmissing \
    )
fi

log.notice 'Calling dh_make'
log.debug "\tdh_make ${DH_MAKE_ARGS[*]}"
dh_make \
    ${DH_MAKE_ARGS[*]} \
    || exit $?

log.notice 'Editing control file...'
while [ true ]; do
    vi DEBIAN/control && break;
done
log.notice 'Finished editing control file...'

cp -rv debian/* ${PKG_DEBIAN_DIR}/

