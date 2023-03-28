# TODO not finished, need libpcap

if [ ! "$_kismet_INCLUDED_" = "1" ]; then
_kismet_INCLUDED_=1


feature_kismet() {
	FEAT_NAME="kismet"
	FEAT_LIST_SCHEMA="2021-06-R1:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="Kismet is a wireless network and device detector, sniffer, wardriving tool, and WIDS (wireless intrusion detection) framework."
	FEAT_LINK="https://github.com/kismetwireless/kismet https://www.kismetwireless.net"
}

feature_kismet_2021-06-R1() {
	FEAT_VERSION=2021-06-R1

	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2 sqlite#^3_35 libwebsockets#^4_2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/kismetwireless/kismet/archive/refs/tags/kismet-2021-05-R1.tar.gz"
	FEAT_SOURCE_URL_FILENAME="kismet-2021-05-R1.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_kismet_link"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/kis"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_kismet_link() {


	__link_feature_library "zlib"
	__link_feature_library "sqlite"

	#__link_feature_library "libwebsockets"

	# __link_feature_library "gettext#0_19_4"

	__link_feature_library "libwebsockets" "GET_FLAGS _libwebsockets"
	export libwebsockets_CFLAGS="$_libwebsockets_C_CXX_FLAGS $_libwebsockets_CPP_FLAGS"
	export libwebsockets_LIBS="$_libwebsockets_LINK_FLAGS"

	# __link_feature_library "sdl#1_2_15" "GET_FOLDER _sdl FORCE_INCLUDE_FOLDER include/SDL NO_SET_FLAGS LIBS_NAME SDL"

	# AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --with-sdl-prefix=$_sdl_ROOT"

	# __link_feature_library "sdl-mixer#1_2_12" "GET_FLAGS _mixer FORCE_INCLUDE_FOLDER include/SDL"
	# #export SDLMIXER_CFLAGS="$_mixer_C_CXX_FLAGS $_mixer_CPP_FLAGS"
	# #export SDLMIXER_LIBS="$_mixer_LINK_FLAGS"

	# __link_feature_library "sdl-image#1_2_12" "FORCE_INCLUDE_FOLDER include/SDL"
	# __link_feature_library "sdl-gfx#2_0_25" "FORCE_INCLUDE_FOLDER include/SDL"
	# __link_feature_library "sdl-ttf#2_0_11" "FORCE_INCLUDE_FOLDER include/SDL"
}



feature_kismet_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	__set_toolset "STANDARD"

	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	#AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=



	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "SOURCE_KEEP"



}

fi
