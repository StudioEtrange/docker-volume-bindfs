if [ ! "$_libwebsockets_INCLUDED_" = "1" ]; then
_libwebsockets_INCLUDED_=1



feature_libwebsockets() {
	FEAT_NAME="libwebsockets"
	FEAT_LIST_SCHEMA="4_2_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="Libwebsockets (LWS) is a flexible, lightweight pure C library for implementing modern network protocols easily with a tiny footprint, using a nonblocking event loop."
	FEAT_LINK="https://github.com/warmcat/libwebsockets https://libwebsockets.org/"
}

feature_libwebsockets_4_2_0() {
	FEAT_VERSION="4_2_0"

	FEAT_SOURCE_DEPENDENCIES="FORCE_ORIGIN_STELLA openssl#^1_1"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/warmcat/libwebsockets/archive/refs/tags/v4.2.0.tar.gz"
	FEAT_SOURCE_URL_FILENAME="libwebsockets-$FEAT_VERSION.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_libwebsockets_link"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/lib/libwebsockets.so"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_libwebsockets_link() {
	__link_feature_library "FORCE_ORIGIN_STELLA openssl#^1_1"
}

feature_libwebsockets_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "CMAKE"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=



	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"




}


fi
