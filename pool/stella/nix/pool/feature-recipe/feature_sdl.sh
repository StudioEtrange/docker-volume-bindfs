if [ ! "$_SDL_INCLUDED_" = "1" ]; then
_SDL_INCLUDED_=1


# freeciv openttd angband
feature_sdl() {
	FEAT_NAME=sdl
	FEAT_LIST_SCHEMA="2_0_10:source 2_0_3:source 1_2_15:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="Simple DirectMedia Layer is a cross-platform development library designed to provide low level access to audio, keyboard, mouse, joystick, and graphics hardware via OpenGL and Direct3D."
	FEAT_LINK="https://www.libsdl.org/"
}


feature_sdl_2_0_10() {
	FEAT_VERSION="2_0_10"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://www.libsdl.org/release/SDL2-2.0.10.tar.gz"
	FEAT_SOURCE_URL_FILENAME="SDL2-2.0.10.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libSDL2.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_sdl_2_0_3() {
	FEAT_VERSION="2_0_3"


	FEAT_SOURCE_URL="https://www.libsdl.org/release/SDL2-2.0.3.tar.gz"
	FEAT_SOURCE_URL_FILENAME="SDL2-2.0.3.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libSDL2.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_sdl_1_2_15() {
	FEAT_VERSION="1_2_15"


	FEAT_SOURCE_URL="https://www.libsdl.org/release/SDL-1.2.15.tar.gz"
	FEAT_SOURCE_URL_FILENAME="SDL-1.2.15.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_sdl_1_2_15_callback"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libSDL.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_sdl_1_2_15_callback() {

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ];then
		# Related ticket: https://bugzilla.libsdl.org/show_bug.cgi?id=2085
		__get_resource "patch-sdl" "https://bugzilla-attachments.libsdl.org/attachment.cgi?id=1320" "HTTP" "$SRC_DIR" "FORCE_NAME patch-sdl1-1320.patch"
		__get_resource "patch-sdl" "https://bugzilla-attachments.libsdl.org/attachment.cgi?id=1324" "HTTP" "$SRC_DIR" "FORCE_NAME patch-sdl1-1324.patch"

		cd "$SRC_DIR"
		patch -Np1 < patch-sdl1-1320.patch
		patch -Np1 < patch-sdl1-1324.patch
	fi

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-assembly --without-x"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


}




feature_sdl_install_source() {
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
