if [ ! "$_libwww_INCLUDED_" = "1" ]; then
_libwww_INCLUDED_=1

# TODO need perl as toolset while building source

feature_libwww() {
	FEAT_NAME=libwww
	FEAT_LIST_SCHEMA="5_4_1:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}


feature_libwww_5_4_1() {
	FEAT_VERSION=5_4_1
	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2 openssl#1_0_2k"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/w3c/libwww/releases/download/5.4.1/w3c-libwww-5.4.1.tgz
	FEAT_SOURCE_URL_FILENAME=w3c-libwww-5.4.1.tgz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_libwww_link"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/w3c
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin
}

feature_libwww_link() {
	__link_feature_library "zlib#^1_2"
	__link_feature_library "openssl#1_0_2k"
}

feature_libwww_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"

	__add_toolset "autotools"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--enable-shared --enable-static --disable-dependency-tracking \
	 		--with-ssl --with-zlib --with-dav --with-md5"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"


}


fi
