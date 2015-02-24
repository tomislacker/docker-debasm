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
    --yes \
)

if [ -d debian ]; then
    DH_MAKE_ARGS+=( \
        --addmissing \
    )
fi

log.notice 'Calling dh_make'
log.debug "\tdh_make ${DH_MAKE_ARGS[*]}"
dh_make \
    ${DH_MAKE_ARGS[*]} \
    1>>/dev/null \
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

if [ -n "$PKG_FORMAT" ]; then
    log.warn "Overriding debian/source/format to '${PKG_FORMAT}'"
    echo "1.0" > debian/source/format
fi

if [ -n "$PKG_NODEFAULTS" ]; then
    log.notice 'Removing default files'
    rm -f debian/*.ex
fi

log.notice 'Starting debuild ...'
DEBUILD_ARGS=( \
    -us \
    -uc \
)
log.debug "\tdebuild ${DEBUILD_ARGS[*]}"
debuild ${DEBUILD_ARGS[*]}
log.notice 'Build complete'

#eval /bin/bash -i

