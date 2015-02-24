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

dumpVariables.prePkgBuild

# Determine where the package will be assembled
log.debug "Copying pkgsrc '/pkgsrc' -> '${PKG_TEMP_DIR}'"
mkdir -p "${PKG_TEMP_DIR}"
cp -r /pkgsrc/* "${PKG_TEMP_DIR}" || exit $?

cd "${PKG_TEMP_DIR}"

DH_MAKE_ARGS=( \
    --native \
    --single \
    --email ${PKG_USER_EMAIL} \
    --addmissing \
    --yes \
)

log.notice 'Calling dh_make'
dh_make \
    ${DH_MAKE_ARGS[*]} \
    >>/dev/null \
    2>>/dev/null \
    || exit $?

log.notice 'Pruning debian/ dir'
rm \
    debian/README \
    debian/README.Debian \
    debian/README.source

log.notice 'Editing control file...'
while [ true ]; do
    vi debian/control && break;
done
log.notice 'Finished editing control file...'

log.notice 'Build complete'

#eval /bin/bash -i

