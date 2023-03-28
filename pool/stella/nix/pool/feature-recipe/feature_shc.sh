if [ ! "$_SHC_INCLUDED_" = "1" ]; then
_SHC_INCLUDED_=1


feature_shc() {
	FEAT_NAME=shc
	FEAT_LIST_SCHEMA="4_0_3:source 4_0_1:source studioetrange-fork:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="Shell script compiler"
	FEAT_LINK="https://github.com/neurobin/shc"
}



feature_shc_studioetrange-fork() {

	FEAT_VERSION=studioetrange-fork

	FEAT_SOURCE_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/StudioEtrange/shc/archive/release.zip"
	FEAT_SOURCE_URL_FILENAME="shc-studioetrange-fork.zip"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"


	FEAT_INSTALL_TEST=$FEAT_INSTALL_ROOT/bin/shc
	FEAT_SEARCH_PATH=$FEAT_INSTALL_ROOT/bin

}

feature_shc_4_0_3() {

	FEAT_VERSION=4_0_3

	FEAT_SOURCE_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/neurobin/shc/archive/4.0.3.zip"
	FEAT_SOURCE_URL_FILENAME="shc-v4.0.3.zip"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"


	FEAT_INSTALL_TEST=$FEAT_INSTALL_ROOT/bin/shc
	FEAT_SEARCH_PATH=$FEAT_INSTALL_ROOT/bin

}



feature_shc_4_0_1() {

	FEAT_VERSION=4_0_1

	FEAT_SOURCE_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/neurobin/shc/archive/4.0.1.zip"
	FEAT_SOURCE_URL_FILENAME="shc-v4.0.1.zip"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"


	FEAT_INSTALL_TEST=$FEAT_INSTALL_ROOT/bin/shc
	FEAT_SEARCH_PATH=$FEAT_INSTALL_ROOT/bin

}




feature_shc_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"

	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

}




fi
