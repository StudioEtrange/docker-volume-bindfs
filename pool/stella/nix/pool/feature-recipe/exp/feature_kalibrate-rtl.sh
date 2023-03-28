if [ ! "$_kalibratertl_INCLUDED_" = "1" ]; then
_kalibratertl_INCLUDED_=1

# TODO DO NOT WORK
# http://askubuntu.com/questions/567813/automake-does-not-find-pkg-config-macros

feature_kalibrate-rtl() {
	FEAT_NAME=kalibrate-rtl
	FEAT_LIST_SCHEMA="SNAPSHOT:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}



feature_kalibrate-rtl_SNAPSHOT() {
	FEAT_VERSION=SNAPSHOT


	FEAT_SOURCE_DEPENDENCIES="rtl-sdr#SNAPSHOT libusb#1_0_21 fftw#3_3_6"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/steve-m/kalibrate-rtl
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=GIT

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_kalibrate-rtl_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/kalibrate-rtl
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

	FEAT_GIT_TAG="master"

}

feature_kalibrate-rtl_link() {
	__link_feature_library "rtl-sdr" "USE_PKG_CONFIG"
	__link_feature_library "libusb"
	__link_feature_library "fftw" "USE_PKG_CONFIG"
}



feature_kalibrate-rtl_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE VERSION $FEAT_GIT_TAG"

	__set_toolset "STANDARD"
	__add_toolset "autotools"

export AL_OPTS=-I/Users/nomorgan/WORK/stella/workspace/toolset_darwin/macos/pkgconfig/0_29/share/aclocal
export ACLOCAL="aclocal -I/Users/nomorgan/WORK/stella/workspace/toolset_darwin/macos/pkgconfig/0_29/share/aclocal"
#http://askubuntu.com/questions/567813/automake-does-not-find-pkg-config-macros

	AUTO_INSTALL_CONF_FLAG_PREFIX=""
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback


	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD AUTOTOOLS bootstrap SOURCE_KEEP"

		echo "XXXX $AL_OPTS"

	#__copy_folder_content_into "$SRC_DIR/" "$INSTALL_DIR/"

	#__del_folder "$SRC_DIR"

	#__inspect_and_fix_build "$INSTALL_DIR"

}


fi
