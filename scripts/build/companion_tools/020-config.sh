# Build script for config.guess/config.sub

do_companion_tools_config_get() {
    if [ "${CT_CONFIGURE_has_git}" = "y" ]; then
        CT_GetGit config "${CT_CONFIG_SUB_GIT_CSET}" git://git0.savannah.gnu.org/config.git
    elif ! CT_GetLocal "config-${CT_CONFIG_SUB_GIT_CSET}"; then
TBD handle FORBID_DOWNLOADS? Mirrors? or modify GetFile to allow custom URLs and postprocessing?
        # This is a small project - pull over HTTP. But HTTP gives a short hash
        # in the path name, so we'll need to postprocess it.
        CT_DoGetFile "http://git.savannah.gnu.org/gitweb/?p=config.git;a=snapshot;h=${CT_CONFIG_SUB_GIT_CSET};sf=tgz" \
            config-tmp-${CT_CONFIG_SUB_GIT_CSET}.tar.gz
        CT_DoExecLog ALL mkdir "${CT_TARBALLS_DIR}/config-${CT_CONFIG_SUB_GIT_CSET}"
        CT_DoExecLog ALL tar xvzf "${CT_TARBALLS_DIR}/config-tmp-${CT_CONFIG_SUB_GIT_CSET}.tar.gz" \
            -C "${CT_TARBALLS_DIR}/config-${CT_CONFIG_SUB_GIT_CSET}" \
            --strip-components=1
        CT_DoExecLog ALL rm -f "${CT_TARBALLS_DIR}/config-${CT_CONFIG_SUB_GIT_CSET}.tar.gz"
        CT_DoExecLog ALL tar cvzf "${CT_TARBALLS_DIR}/config-${CT_CONFIG_SUB_GIT_CSET}.tar.gz" \
            -C "${CT_TARBALLS_DIR}" "config-${CT_CONFIG_SUB_GIT_CSET}"
        CT_DoExecLog ALL rm -r "${CT_TARBALLS_DIR}/config-${CT_CONFIG_SUB_GIT_CSET}"
        CT_DoExecLog ALL rm "${CT_TARBALLS_DIR}/config-tmp-${CT_CONFIG_SUB_GIT_CSET}.tar.gz"
        CT_SaveLocal "${CT_TARBALLS_DIR}/config-${CT_CONFIG_SUB_GIT_CSET}.tar.gz"
    fi
}

do_companion_tools_config_extract() {
    CT_Extract "config-${CT_CONFIG_SUB_GIT_CSET}"
    CT_Patch "config" "${CT_CONFIG_SUB_GIT_CSET}"
}

do_companion_tools_make_for_build() {
    local srcdir="${CT_SRC_DIR}/config-${CT_CONFIG_SUB_GIT_CSET}"

    CT_DoStep INFO "Installing config.sub/config.guess"
    if [ "${CT_COMPLIBS_CHECK}" = "y" ]; then
        CT_DoLog EXTRA "Checking config.sub/config.guess"
        CT_DoExecLog make -C "${srcdir}" check
    fi
    CT_DoLog EXTRA "Installing config.sub/config.guess"
    CT_DoExecLog ALL mkdir -p "${CT_BUILD_COMPTOOLS_DIR}/bin"
    CT_DoExecLog ALL install -m 0755 "${srcdir}/config.guess" \
        "${CT_BUILD_COMPTOOLS_DIR}/bin/config.guess"
    CT_DoExecLog ALL install -m 0755 "${srcdir}/config.sub" \
        "${CT_BUILD_COMPTOOLS_DIR}/bin/config.sub"
    CT_EndStep
}

do_companion_tools_make_for_host() {
    :
}
