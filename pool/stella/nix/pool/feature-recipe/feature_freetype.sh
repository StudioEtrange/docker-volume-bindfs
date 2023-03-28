if [ ! "$_FREETYPE_INCLUDED_" = "1" ]; then
_FREETYPE_INCLUDED_=1

# TODO
# PB1
# on ubuntu : work only with FORCE_DYNAMIC for all dep
# PB2
# on ubuntu :
# checking for BZIP2... no
# checking for BZ2_bzDecompress in -lbz2... no
# checking for LIBPNG... no

feature_freetype() {
	FEAT_NAME=freetype
	FEAT_LIST_SCHEMA="2_6_0:source 2_6_1:source 2_10_1:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="A free, high-quality, and portable font engine"
	FEAT_LINK="https://www.freetype.org/"
}


feature_freetype_2_10_1() {
	FEAT_VERSION="2_10_1"
	FEAT_SOURCE_DEPENDENCIES="libpng#1_6_17 bzip2#1_0_6 zlib#^1_2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="http://downloads.sourceforge.net/project/freetype/freetype2/2.10.1/freetype-2.10.1.tar.gz"
	FEAT_SOURCE_URL_FILENAME="freetype-2.10.1.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"


	FEAT_SOURCE_CALLBACK="feature_freetype_link"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libfreetype.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin
}

feature_freetype_2_6_1() {
	FEAT_VERSION="2_6_1"
	FEAT_SOURCE_DEPENDENCIES="libpng#1_6_17 bzip2#1_0_6 zlib#^1_2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="http://downloads.sourceforge.net/project/freetype/freetype2/2.6.1/freetype-2.6.1.tar.bz2"
	FEAT_SOURCE_URL_FILENAME="freetype-2.6.1.tar.bz2"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_freetype_link"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libfreetype.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin
}

feature_freetype_2_6_0() {
	FEAT_VERSION=2_6_0
	FEAT_SOURCE_DEPENDENCIES="libpng#1_6_17 bzip2#1_0_6 zlib#^1_2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://downloads.sf.net/project/freetype/freetype2/2.6/freetype-2.6.tar.bz2
	FEAT_SOURCE_URL_FILENAME=freetype-2.6.tar.bz2
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_freetype_2_6_0_patch feature_freetype_link"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libfreetype.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin
}

feature_freetype_2_6_0_patch() {
	__get_resource "freetype26 patch" "https://gist.githubusercontent.com/anonymous/b47d77c41a6801879fd2/raw/fc21c3516b465095da7ed13f98bea491a7d18bbd" "HTTP" "$SRC_DIR" "FORCE_NAME freetype26-patch-fc21c3516b465095da7ed13f98bea491a7d18bbd.patch"
	cd "$SRC_DIR"
	patch -Np1 < freetype26-patch-fc21c3516b465095da7ed13f98bea491a7d18bbd.patch
}

feature_freetype_link() {
	__link_feature_library "libpng#1_6_17" "FORCE_STATIC"
	__link_feature_library "bzip2#1_0_6" "FORCE_STATIC"
	__link_feature_library "zlib#^1_2" "FORCE_DYNAMIC"
}

feature_freetype_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--without-harfbuzz"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"


}



fi
