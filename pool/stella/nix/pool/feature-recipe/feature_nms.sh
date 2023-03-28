if [ ! "$_nms_INCLUDED_" = "1" ]; then
_nms_INCLUDED_=1


feature_nms() {
	FEAT_NAME=nms
	FEAT_LIST_SCHEMA="0_3_3:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="A command line tool that recreates the famous data decryption effect seen in the 1992 movie Sneakers."
	FEAT_LINK="https://github.com/bartobri/no-more-secrets"
}

feature_nms_0_3_3() {
	FEAT_VERSION=0_3_3

	FEAT_SOURCE_URL="https://github.com/bartobri/no-more-secrets/archive/v0.3.3.tar.gz"
	FEAT_SOURCE_URL_FILENAME=nms-v0.3.3.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/nms
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin
}



feature_nms_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"

	__set_toolset "STANDARD"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_CONFIG POST_BUILD_STEP sneakers install"


}


fi
