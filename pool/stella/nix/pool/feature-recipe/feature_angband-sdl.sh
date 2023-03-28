if [ ! "$_angbandsdl_INCLUDED_" = "1" ]; then
_angbandsdl_INCLUDED_=1


# http://angband.oook.cz/
# http://rephial.org/
# https://github.com/angband/angband/

# TODO On MacOS, SDL version do not play well, should build instead with src/Makefile.osx ? or do not provide SDL version MacOS ?


# launch sdl based : angband -msdl -ssdl

. "${STELLA_FEATURE_RECIPE}/feature_angband.sh"

feature_angband-sdl() {
	feature_angband
	FEAT_NAME=angband-sdl

	FEAT_DESC="${FEAT_DESC} - SDL version"

}

feature_angband-sdl_4_1_3() {
	feature_angband_4_1_3
	FEAT_VERSION=4_1_3

	FEAT_SOURCE_DEPENDENCIES="${FEAT_SOURCE_DEPENDENCIES} sdl#1_2_15 sdl-mixer#1_2_12 sdl-image#1_2_12 sdl-ttf#2_0_11"
	#FEAT_SOURCE_DEPENDENCIES="sdl#1_2_15 sdl-mixer#1_2_12 sdl-image#1_2_12 sdl-ttf#2_0_11"

	FEAT_SOURCE_CALLBACK=feature_angband-sdl_link
}

feature_angband-sdl_4_0_4() {
	feature_angband_4_0_4
	FEAT_VERSION=4_0_4

	FEAT_SOURCE_DEPENDENCIES="${FEAT_SOURCE_DEPENDENCIES} sdl#1_2_15 sdl-mixer#1_2_12 sdl-image#1_2_12 sdl-ttf#2_0_11"
	#FEAT_SOURCE_DEPENDENCIES="sdl#1_2_15 sdl-mixer#1_2_12 sdl-image#1_2_12 sdl-ttf#2_0_11"

	FEAT_SOURCE_CALLBACK=feature_angband-sdl_link
}

feature_angband-sdl_link() {
	#AUTO_INSTALL_CONF_FLAG_POSTFIX="--enable-sdl --enable-curses --disable-x11"
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--enable-sdl --disable-x11"

	__link_feature_library "ncurses"

	__link_feature_library "sdl#1_2_15" "GET_FOLDER _sdl FORCE_INCLUDE_FOLDER include/SDL NO_SET_FLAGS LIBS_NAME SDL"
	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --with-sdl-prefix=$_sdl_ROOT"

	__link_feature_library "sdl-mixer#1_2_12" "FORCE_INCLUDE_FOLDER include/SDL"
	__link_feature_library "sdl-image#1_2_12" "FORCE_INCLUDE_FOLDER include/SDL"
	__link_feature_library "sdl-ttf#2_0_11" "FORCE_INCLUDE_FOLDER include/SDL"
}


feature_angband-sdl_install_source() {
	feature_angband_install_source
}


fi
