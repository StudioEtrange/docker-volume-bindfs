if [ ! "$_sdlttf_INCLUDED_" = "1" ]; then
_sdlttf_INCLUDED_=1

#https://www.libsdl.org/projects/SDL_ttf/

# NOTE this use sdl-config and freetype-config binaries to set correct flag

# sdl 2.x => sdl-ttf 2_0_12
# sdl 1.2.x => sdl-ttf 2_0_11

feature_sdl-ttf() {
	FEAT_NAME=sdl-ttf
	FEAT_LIST_SCHEMA="2_0_15:source 2_0_12:source 2_0_11:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="SDL_ttf is a TrueType font rendering library that is used with the SDL library, and almost as portable."
	FEAT_LINK="https://www.libsdl.org/projects/SDL_ttf/"
}




feature_sdl-ttf_2_0_15() {
	FEAT_VERSION="2_0_15"

	FEAT_SOURCE_DEPENDENCIES="sdl#^2 freetype#^2_6"

	FEAT_SOURCE_URL="https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.15.tar.gz"
	FEAT_SOURCE_URL_FILENAME="SDL2_ttf-2.0.15.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_sdl-ttf_link_sdl2"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libSDL2_ttf.a
	FEAT_SEARCH_PATH=

}



feature_sdl-ttf_2_0_12() {
	FEAT_VERSION=2_0_12

	FEAT_SOURCE_DEPENDENCIES="sdl#^2 freetype#^2_6"


	FEAT_SOURCE_URL="https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.12.tar.gz"
	FEAT_SOURCE_URL_FILENAME=SDL2_ttf-2.0.12.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=feature_sdl-ttf_link_sdl2

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libSDL2_ttf.a
	FEAT_SEARCH_PATH=

}

feature_sdl-ttf_2_0_11() {
	FEAT_VERSION=2_0_11

	FEAT_SOURCE_DEPENDENCIES="sdl#^1 freetype#^2_6"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.11.tar.gz
	FEAT_SOURCE_URL_FILENAME=SDL_ttf-2.0.11.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP


	FEAT_SOURCE_CALLBACK=feature_sdl-ttf_link_sdl1

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libSDL_ttf.a
	FEAT_SEARCH_PATH=

}

feature_sdl-ttf_link_sdl1() {
	__link_feature_library "sdl#^1" "GET_FOLDER _sdl1 FORCE_INCLUDE_FOLDER include/SDL NO_SET_FLAGS"
	__link_feature_library "freetype#^2_6" "GET_FOLDER _freetype NO_SET_FLAGS"

	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --with-sdl-prefix=$_sdl1_ROOT --with-freetype-prefix=$_freetype_ROOT"
}


feature_sdl-ttf_link_sdl2() {
	__link_feature_library "sdl#^2" "GET_FOLDER _sdl2 FORCE_INCLUDE_FOLDER include/SDL NO_SET_FLAGS"
	__link_feature_library "freetype#^2_6" "GET_FOLDER _freetype NO_SET_FLAGS"

	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --with-sdl-prefix=$_sdl2_ROOT --with-freetype-prefix=$_freetype_ROOT"
}


feature_sdl-ttf_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__feature_callback


	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

}




fi
