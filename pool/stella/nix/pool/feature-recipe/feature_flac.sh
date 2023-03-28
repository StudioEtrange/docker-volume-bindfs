if [ ! "$_flac_INCLUDED_" = "1" ]; then
_flac_INCLUDED_=1

# https://github.com/Homebrew/homebrew/blob/master/Library/Formula/flac.rb

feature_flac() {
	FEAT_NAME=flac
	FEAT_LIST_SCHEMA="1_3_1:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}




feature_flac_1_3_1() {
	FEAT_VERSION=1_3_1

	FEAT_SOURCE_DEPENDENCIES="libogg#DEV20150926"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://downloads.xiph.org/releases/flac/flac-1.3.1.tar.xz
	FEAT_SOURCE_URL_FILENAME=flac-1.3.1.tar.xz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_flac_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/flac
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_flac_link() {
	__link_feature_library "libogg#DEV20150926"

}

feature_flac_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking \
      --disable-debug \
      --enable-sse \
      --enable-static"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

     [ "$STELLA_BUILD_ARCH" = "x86" ] && AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --disable-asm-optimizations"

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

}




fi
