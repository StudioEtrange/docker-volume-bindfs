if [ ! "$_angband_INCLUDED_" = "1" ]; then
_angband_INCLUDED_=1


# http://angband.oook.cz/
# http://rephial.org/
# https://github.com/angband/angband/

# TODO On MacOS, SDL version do not play well, should build instead with src/Makefile.osx ? or do not provide SDL version MacOS ?

# launch curses based : angband -mgcu
# launch sdl based : angband -msdl -ssdl

feature_angband() {
	FEAT_NAME=angband

	FEAT_LIST_SCHEMA="4_0_4:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="A free, single-player roguelike dungeon exploration game"
	FEAT_LINK="http://rephial.org/"

}

feature_angband_4_0_4() {
	FEAT_VERSION=4_0_4


	FEAT_SOURCE_DEPENDENCIES="sdl#1_2_15 ncurses#5_9 sdl-mixer#1_2_12 sdl-image#1_2_12 sdl-ttf#2_0_11"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/angband/angband/archive/4.0.4.tar.gz
	FEAT_SOURCE_URL_FILENAME=angband-4.0.4.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_angband_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/games/angband
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/games

}

feature_angband_link() {
	__link_feature_library "ncurses#5_9"

	__link_feature_library "sdl#1_2_15" "GET_FOLDER _sdl FORCE_INCLUDE_FOLDER include/SDL NO_SET_FLAGS LIBS_NAME SDL"
	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --with-sdl-prefix=$_sdl_ROOT"

	__link_feature_library "sdl-mixer#1_2_12" "FORCE_INCLUDE_FOLDER include/SDL"
	__link_feature_library "sdl-image#1_2_12" "FORCE_INCLUDE_FOLDER include/SDL"
	__link_feature_library "sdl-ttf#2_0_11" "FORCE_INCLUDE_FOLDER include/SDL"
}


feature_angband_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"
	__add_toolset "autotools"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"



	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--enable-sdl --enable-curses --disable-x11"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD AUTOTOOLS autogen"


}


fi
