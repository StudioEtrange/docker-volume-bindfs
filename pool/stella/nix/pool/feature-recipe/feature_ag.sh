if [ ! "$_ag_INCLUDED_" = "1" ]; then
_ag_INCLUDED_=1

# darwin -- OK -- 20151012

feature_ag() {
	FEAT_NAME=ag
	FEAT_LIST_SCHEMA="1_0_2:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_ag_1_0_2() {
	FEAT_VERSION=1_0_2


	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2 pcre#8_36 xzutils#5_2_1"
	FEAT_BINARY_DEPENDENCIES=
	FEAT_SOURCE_URL=https://geoff.greer.fm/ag/releases/the_silver_searcher-1.0.2.tar.gz
	FEAT_SOURCE_URL_FILENAME=the_silver_searcher-1.0.2.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_ag_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/ag
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_ag_link() {
	__link_feature_library "zlib" "FORCE_DYNAMIC"
	__link_feature_library "pcre" "GET_FLAGS _pcre FORCE_STATIC LIBS_NAME pcre NO_SET_FLAGS"
	__link_feature_library "xzutils" "GET_FLAGS _lzma LIBS_NAME lzma NO_SET_FLAGS"

	AUTO_INSTALL_CONF_FLAG_PREFIX="LZMA_CFLAGS=\"$_lzma_C_CXX_FLAGS $_lzma_CPP_FLAGS\" LZMA_LIBS=\"$_lzma_LINK_FLAGS\" PCRE_CFLAGS=\"$_pcre_C_CXX_FLAGS $_pcre_CPP_FLAGS\" PCRE_LIBS=\"$_pcre_LINK_FLAGS\""
}


feature_ag_install_source() {
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
