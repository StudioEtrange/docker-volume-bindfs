if [ ! "$_oolite_INCLUDED_" = "1" ]; then
_oolite_INCLUDED_=1

# TODO : to finish
# https://github.com/OoliteProject/oolite

# need gnustep-make https://github.com/Homebrew/homebrew/blob/master/Library/Formula/gnustep-make.rb
feature_oolite() {
	FEAT_NAME=oolite

	FEAT_LIST_SCHEMA="1_82:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"


}

feature_oolite_1_82() {
	FEAT_VERSION=1_82


	FEAT_SOURCE_DEPENDENCIES="gnustep-make#2_6_7"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/OoliteProject/oolite/releases/download/1.82/oolite-source-1.82.tar.bz2
	FEAT_SOURCE_URL_FILENAME=oolite-source-1.82.tar.bz2
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/oolite
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_oolite_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_CONFIG NO_OUT_OF_TREE_BUILD SOURCE_KEEP"




}


fi
