if [ ! "$_dumb_INCLUDED_" = "1" ]; then
_dumb_INCLUDED_=1



feature_dumb() {
	FEAT_NAME=dumb
	FEAT_LIST_SCHEMA="0_9_3:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="DUMB is an IT, XM, S3M and MOD player library"
	FEAT_LINK="http://dumb.sourceforge.net"
}




feature_dumb_0_9_3() {
	FEAT_VERSION=0_9_3

	FEAT_SOURCE_DEPENDENCIES="readline zlib#^1_2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://downloads.sourceforge.net/project/dumb/dumb/0.9.3/dumb-0.9.3.tar.gz
	FEAT_SOURCE_URL_FILENAME=dumb-0.9.3.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_dumb_conftools_0_9_3
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libdumb.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_dumb_conftools_0_9_3() {
	__get_resource "libdumb conf tools" "http://downloads.sourceforge.net/project/dumb/dumb/0.9.3/dumb-0.9.3-autotools.tar.gz" "HTTP_ZIP" "$SRC_DIR" "STRIP"


}

feature_dumb_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

}




fi
