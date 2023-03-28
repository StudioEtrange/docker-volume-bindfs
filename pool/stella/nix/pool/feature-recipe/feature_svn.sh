if [ ! "$_svn_INCLUDED_" = "1" ]; then
_svn_INCLUDED_=1

# TODO :
# depend on zlib, expat, sqllite3, libsasl2


feature_svn() {
	FEAT_NAME=svn
	FEAT_LIST_SCHEMA="1_8_17:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_svn_1_8_17() {
	FEAT_VERSION=1_8_17

	FEAT_SOURCE_DEPENDENCIES="apr#1_5_2 apr-util#1_5_4  sqlite#3_18_0"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://www.apache.org/dist/subversion/subversion-1.8.17.tar.gz
	FEAT_SOURCE_URL_FILENAME=subversion-1.8.17.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_svn_source_callback
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/svn
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_svn_source_callback() {
	__link_feature_library "apr"
	__link_feature_library "apr-util"
	__link_feature_library "sqlite"
}

feature_svn_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback
	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

}



fi
