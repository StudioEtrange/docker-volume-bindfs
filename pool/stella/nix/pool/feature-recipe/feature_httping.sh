if [ ! "$_httping_INCLUDED_" = "1" ]; then
_httping_INCLUDED_=1


feature_httping() {
	FEAT_NAME=httping
	FEAT_LIST_SCHEMA="2_5:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}


feature_httping_2_5() {
	FEAT_VERSION=2_5
	FEAT_SOURCE_DEPENDENCIES="ncurses#6_0 openssl fftw"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/flok99/httping/archive/v2.5.tar.gz
	FEAT_SOURCE_URL_FILENAME=httping-v2.5.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_httping_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/httping
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_httping_link() {
	__link_feature_library "ncurses" "FORCE_DYNAMIC"
	__link_feature_library "openssl"
	__link_feature_library "fftw"
}


feature_httping_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--with-ncurses --with-openssl --with-fftw3 --with-tfo"
	AUTO_INSTALL_BUILD_FLAG_PREFIX="PREFIX=$FEAT_INSTALL_ROOT"
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD"

}



fi
