if [ ! "$_UNNETHACK_INCLUDED_" = "1" ]; then
_UNNETHACK_INCLUDED_=1

# OK


feature_unnethack() {
	FEAT_NAME="unnethack"
	FEAT_LIST_SCHEMA="5_3_2:source 5_1_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="template is foo"
	FEAT_LINK="https://github.com/UnNetHack/UnNetHack https://unnethack.wordpress.com/"
}



feature_unnethack_5_3_2() {
	FEAT_VERSION="unnethack_5_3_2"

	# depend on ncurses
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/UnNetHack/UnNetHack/archive/refs/tags/5.3.2.tar.gz"
	FEAT_SOURCE_URL_FILENAME="unnethack-5.3.2.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/unnethack"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_unnethack_5_1_0() {
	FEAT_VERSION="unnethack_5_1_0"

	# depend on ncurses
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="http://sourceforge.net/projects/unnethack/files/unnethack/5.1.0/unnethack-5.1.0-20131208.tar.gz"
	FEAT_SOURCE_URL_FILENAME="unnethack-5.1.0-20131208.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/unnethack"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}




feature_unnethack_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=-"-with-owner=`id -un` --with-group=`id -gn` --enable-wizmode=`id -un`"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD"


}



fi
