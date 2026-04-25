if [ ! "$_MOON_BUGGY_INCLUDED_" = "1" ]; then
_MOON_BUGGY_INCLUDED_=1

feature_moon-buggy() {
	FEAT_NAME="moon-buggy"
	FEAT_LIST_SCHEMA="master:source"
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="drive some car across the moon"
	FEAT_LINK="https://github.com/seehuhn/moon-buggy https://www.seehuhn.de/pages/moon-buggy.html"
}

feature_moon-buggy_master() {
	FEAT_VERSION="master"

	FEAT_SOURCE_DEPENDENCIES="ncurses#6_5"

	FEAT_SOURCE_URL="https://github.com/seehuhn/moon-buggy/archive/refs/heads/master.tar.gz"
	FEAT_SOURCE_URL_FILENAME="moon-buggy-master.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK=feature_moon-buggy_link

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/moon-buggy"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"
}

feature_moon-buggy_link() {
	__link_feature_library "ncurses#6_5" "FORCE_DYNAMIC"
}

feature_moon-buggy_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"
	__add_toolset "autotools"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD AUTOTOOLS autogen"
}

fi
