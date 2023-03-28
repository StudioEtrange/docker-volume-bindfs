if [ ! "$_sdlmixer_INCLUDED_" = "1" ]; then
_sdlmixer_INCLUDED_=1

#http://www.libsdl.org/projects/SDL_mixer/

# NOTE this use sdl-config binaries to set correct flag

# sdl 2.x => sdl-mixer 2_0_0
# sdl 1.2.x => sdl-mixer 1_2_12




feature_sdl-mixer() {
	FEAT_NAME=sdl-mixer
	FEAT_LIST_SCHEMA="2_0_4:source 2_0_0:source 1_2_12:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="SDL_mixer is a sound mixing library that is used with the SDL library, and almost as portable. It allows a programmer to use multiple samples along with music without having to code a mixing algorithm themselves. It also simplyfies the handling of loading and playing samples and music from all sorts of file formats."
	FEAT_LINK="https://www.libsdl.org/projects/SDL_mixer/"
}





feature_sdl-mixer_2_0_4() {
	FEAT_VERSION="2_0_4"

	FEAT_SOURCE_DEPENDENCIES="sdl#^2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.4.tar.gz"
	FEAT_SOURCE_URL_FILENAME="SDL2_mixer-2.0.4.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_sdl-mixer_link_sdl2"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libSDL2_mixer.a
	FEAT_SEARCH_PATH=

}

feature_sdl-mixer_2_0_0() {
	FEAT_VERSION="2_0_0"

	FEAT_SOURCE_DEPENDENCIES="sdl#^2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="http://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.0.tar.gz"
	FEAT_SOURCE_URL_FILENAME="SDL2_mixer-2.0.0.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_sdl-mixer_link_sdl2"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libSDL2_mixer.a
	FEAT_SEARCH_PATH=

}

feature_sdl-mixer_1_2_12() {
	FEAT_VERSION=1_2_12

	FEAT_SOURCE_DEPENDENCIES="sdl#^1"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.12.tar.gz
	FEAT_SOURCE_URL_FILENAME=SDL_mixer-1.2.12.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=feature_sdl-mixer_link_sdl1

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libSDL_mixer.a
	FEAT_SEARCH_PATH=

}



feature_sdl-mixer_link_sdl1() {
	__link_feature_library "sdl#^1" "GET_FOLDER _sdl1 FORCE_INCLUDE_FOLDER include/SDL NO_SET_FLAGS"

	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --with-sdl-prefix=$_sdl1_ROOT"
}


feature_sdl-mixer_link_sdl2() {
	__link_feature_library "sdl#^2" "GET_FOLDER _sdl2 FORCE_INCLUDE_FOLDER include/SDL NO_SET_FLAGS"

	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --with-sdl-prefix=$_sdl2_ROOT"
}


feature_sdl-mixer_install_source() {
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
