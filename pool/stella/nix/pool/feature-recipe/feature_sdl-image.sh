if [ ! "$_sdlimage_INCLUDED_" = "1" ]; then
_sdlimage_INCLUDED_=1

#https://www.libsdl.org/projects/SDL_image/

# NOTE this use sdl-config binaries to set correct flag

# sdl 2.x => sdl-image 2_0_0
# sdl 1.2.x => sdl-image 1_2_12

feature_sdl-image() {
	FEAT_NAME=sdl-image
	FEAT_LIST_SCHEMA="2_0_5:source 2_0_0:source 1_2_12:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="SDL_image is an image loading library that is used with the SDL library, and almost as portable. It allows a programmer to use multiple image formats without having to code all the loading and conversion algorithms themselves."
	FEAT_LINK="https://www.libsdl.org/projects/SDL_image/"
}




feature_sdl-image_2_0_5() {
	FEAT_VERSION="2_0_5"

	FEAT_SOURCE_DEPENDENCIES="sdl#^2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.5.tar.gz"
	FEAT_SOURCE_URL_FILENAME="SDL2_image-2.0.0.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"


	FEAT_SOURCE_CALLBACK="feature_sdl-image_link_sdl2"


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libSDL2_image.a
	FEAT_SEARCH_PATH=

}


feature_sdl-image_2_0_0() {
	FEAT_VERSION="2_0_0"

	FEAT_SOURCE_DEPENDENCIES="sdl#^2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.0.tar.gz"
	FEAT_SOURCE_URL_FILENAME="SDL2_image-2.0.0.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"


	FEAT_SOURCE_CALLBACK="feature_sdl-image_link_sdl2"


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libSDL2_image.a
	FEAT_SEARCH_PATH=

}

feature_sdl-image_1_2_12() {
	FEAT_VERSION=1_2_12

	FEAT_SOURCE_DEPENDENCIES="sdl#^1"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz
	FEAT_SOURCE_URL_FILENAME=SDL_image-1.2.12.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=feature_sdl-image_link_sdl1

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libSDL_image.a
	FEAT_SEARCH_PATH=

}



feature_sdl-image_link_sdl1() {
	__link_feature_library "sdl#^1" "GET_FOLDER _sdl1 FORCE_INCLUDE_FOLDER include/SDL NO_SET_FLAGS"

	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --with-sdl-prefix=$_sdl1_ROOT"
}


feature_sdl-image_link_sdl2() {
	__link_feature_library "sdl#^2" "GET_FOLDER _sdl2 FORCE_INCLUDE_FOLDER include/SDL NO_SET_FLAGS"

	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --with-sdl-prefix=$_sdl2_ROOT"
}


feature_sdl-image_install_source() {
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
