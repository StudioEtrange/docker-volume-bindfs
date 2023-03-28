if [ ! "$_fontconfig_INCLUDED_" = "1" ]; then
_fontconfig_INCLUDED_=1

# http://www.linuxfromscratch.org/blfs/view/cvs/general/fontconfig.html
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/fontconfig.rb

feature_fontconfig() {
	FEAT_NAME=fontconfig
	FEAT_LIST_SCHEMA="2_12_1:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}


feature_fontconfig_2_12_1() {
	FEAT_VERSION=2_12_1
	FEAT_SOURCE_DEPENDENCIES="freetype#2_6_1 expat#2_1_0 libiconv#1_14"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.1.tar.gz
	FEAT_SOURCE_URL_FILENAME=fontconfig-2.12.1.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_fontconfig_link"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libfontconfig.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin
}

feature_fontconfig_link() {
	__link_feature_library "libiconv#1_14" "NO_SET_FLAGS GET_FOLDER _iconv"
	__link_feature_library "expat" "NO_SET_FLAGS GET_FOLDER _expat"

	__link_feature_library "freetype" "USE_PKG_CONFIG"

	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --enable-iconv --with-libiconv=$_iconv_ROOT --with-expat=$_expat_ROOT"
}

feature_fontconfig_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	# --enable-libxml2 use libxml2 instead of Expat
	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--enable-static --enable-shared --disable-dependency-tracking --disable-docs"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"


}



fi
