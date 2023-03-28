if [ ! "$_flex_INCLUDED_" = "1" ]; then
_flex_INCLUDED_=1

# https://github.com/Homebrew/homebrew-core/blob/master/Formula/flex.rb
# https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/tools/parsing/flex


feature_flex() {
	FEAT_NAME=flex

	FEAT_LIST_SCHEMA="2_6_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_flex_2_6_0() {
	FEAT_VERSION=2_6_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://downloads.sourceforge.net/flex/flex-2.6.0.tar.bz2
	FEAT_SOURCE_URL_FILENAME=flex-2.6.0.tar.bz2
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/flex
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_flex_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD POST_BUILD_STEP check"

}


fi
