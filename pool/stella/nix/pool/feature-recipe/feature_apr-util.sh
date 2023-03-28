if [ ! "$_aprutil_INCLUDED_" = "1" ]; then
_aprutil_INCLUDED_=1


feature_apr-util() {
	FEAT_NAME=apr-util

	FEAT_LIST_SCHEMA="1_5_4:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"


}

feature_apr-util_1_5_4() {
	FEAT_VERSION=1_5_4


	FEAT_SOURCE_DEPENDENCIES="apr#1_5_2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://archive.apache.org/dist/apr/apr-util-1.5.4.tar.gz
	FEAT_SOURCE_URL_FILENAME=apr-util-1.5.4.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_apr-util_source_callback
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libaprutil-1.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_apr-util_source_callback() {
	__link_feature_library "apr" "GET_FOLDER _apr NO_SET_FLAGS"
	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --with-apr=$_apr_ROOT"
}

feature_apr-util_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--with-apr="
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__feature_callback
	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"


}


fi
