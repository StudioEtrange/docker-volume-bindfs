# shellcheck shell=bash
# shellcheck disable=SC2034
if [ ! "$_nsnake_INCLUDED_" = "1" ]; then
_nsnake_INCLUDED_=1


feature_nsnake() {
	FEAT_NAME="nsnake"
	FEAT_LIST_SCHEMA="3_0_1:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="Nsnake: The classic snake game with textual interface."
	FEAT_LINK="http://nsnake.alexdantas.net"
}


feature_nsnake_3_0_1() {
	FEAT_VERSION="3_0_1"
	FEAT_SOURCE_DEPENDENCIES="ncurses#^5"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/alexdantas/nSnake/archive/v3.0.1.tar.gz"
	FEAT_SOURCE_URL_FILENAME="nsnake-v3.0.1.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_nsnake_link"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_TEST="nsnake"
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/$FEAT_TEST"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_nsnake_link() {

	# NOTE : we need to include folder both from ncurses/include/ncurses AND ncurses/include
	#	     we use SET_FLAGS even if there is no config phase, because we want that the fix phase after build is launched to add rpath. Because we cannot retrieve rpath instructions with GET_FLAGS
	__link_feature_library "ncurses#^5" "GET_FLAGS _ncurses"
	__link_feature_library "ncurses#^5" "GET_FLAGS _ncurses_root NO_SET_FLAGS FORCE_INCLUDE_FOLDER include/ncurses"


	export ncurses_CFLAGS="\"$(__trim $_ncurses_C_CXX_FLAGS $_ncurses_CPP_FLAGS $_ncurses_root_C_CXX_FLAGS $_ncurses_root_CPP_FLAGS)\""
	export ncurses_LIBS="$_ncurses_LINK_FLAGS"

}


feature_nsnake_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE FORCE_NAME $FEAT_SOURCE_URL_FILENAME"

	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX="CFLAGS_PLATFORM=$ncurses_CFLAGS LDFLAGS_PLATFORM=$ncurses_LIBS"
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_CONFIG"



}



fi
