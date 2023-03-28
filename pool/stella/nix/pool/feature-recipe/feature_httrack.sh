if [ ! "$_httrack_INCLUDED_" = "1" ]; then
_httrack_INCLUDED_=1




feature_httrack() {
	FEAT_NAME=httrack
	FEAT_LIST_SCHEMA="3_48_22:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_httrack_3_48_22() {
	FEAT_VERSION=3_48_22

	FEAT_SOURCE_DEPENDENCIES="openssl#1_0_2d zlib#^1_2 libiconv#1_14"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://mirror.httrack.com/historical/httrack-3.48.22.tar.gz
	FEAT_SOURCE_URL_FILENAME=httrack-3.48.22.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_httrack_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/httrack
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin
}

feature_httrack_link() {
	__link_feature_library "openssl#1_0_2d"
	#__link_feature_library "zlib#^1_2" "GET_FOLDER _zlib FORCE_DYNAMIC"
	__link_feature_library "zlib#^1_2" "FORCE_STATIC"
	__link_feature_library "libiconv#1_14" "FORCE_STATIC"
}

feature_httrack_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__set_toolset "STANDARD"

	__feature_callback


	# to build examples without error, because include are not installed in the right places for examples
	STELLA_CPP_FLAGS="$STELLA_CPP_FLAGS -I$FEAT_INSTALL_ROOT/include/httrack"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	# do not use --with-zlib=DIR
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking --enable-online-unit-tests=auto \
						--enable-static --enable-shared --enable-https=yes"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=



	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

}


fi
