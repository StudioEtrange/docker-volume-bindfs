if [ ! "$_PCRE_INCLUDED_" = "1" ]; then
_PCRE_INCLUDED_=1



feature_pcre() {

	FEAT_NAME=pcre
	FEAT_LIST_SCHEMA="8_36:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_pcre_8_36() {
	FEAT_VERSION=8_36

	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2 bzip2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://downloads.sourceforge.net/project/pcre/pcre/8.36/pcre-8.36.tar.bz2
	FEAT_SOURCE_URL_FILENAME=pcre-8.36.tar.bz2
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_pcre_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libpcre.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_pcre_link() {
	__link_feature_library "zlib#^1_2"
	__link_feature_library "bzip2"
}

feature_pcre_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	#__set_toolset "CUSTOM" "CONFIG_TOOL configure BUILD_TOOL make"
	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking \
                          --enable-utf8 \
                          --enable-pcre8 \
                          --enable-pcre16 \
                          --enable-pcre32 \
                          --enable-unicode-properties \
                          --enable-pcregrep-libz \
                          --enable-pcregrep-libbz2 \
                          --enable-jit"

	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

}



fi
