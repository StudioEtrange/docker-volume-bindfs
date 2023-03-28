if [ ! "$_angband_INCLUDED_" = "1" ]; then
_angband_INCLUDED_=1


# http://angband.oook.cz/
# http://rephial.org/
# https://github.com/angband/angband/

# launch curses based : angband -mgcu

feature_angband() {
	FEAT_NAME=angband

	FEAT_LIST_SCHEMA="4_1_3:source 4_0_5:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="A free, single-player roguelike dungeon exploration game - NCurses only"
	FEAT_LINK="http://rephial.org/"

}




feature_angband_4_1_3() {
	FEAT_VERSION=4_1_3

	FEAT_SOURCE_DEPENDENCIES="ncurses#6_1"

	FEAT_SOURCE_URL=https://github.com/angband/angband/archive/4.1.3.tar.gz
	FEAT_SOURCE_URL_FILENAME=angband-4.1.3.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=feature_angband_link

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/games/angband
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/games

}


feature_angband_4_0_5() {
	FEAT_VERSION=4_0_5

	FEAT_SOURCE_DEPENDENCIES="ncurses#5_9"

	FEAT_SOURCE_URL=https://github.com/angband/angband/archive/4.0.5.tar.gz
	FEAT_SOURCE_URL_FILENAME=angband-4.0.5.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=feature_angband_link

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/games/angband
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/games

}

feature_angband_link() {
	__link_feature_library "ncurses"


}


feature_angband_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"
	__add_toolset "autotools"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"



	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--enable-curses --disable-x11"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD AUTOTOOLS autogen"


}


fi
