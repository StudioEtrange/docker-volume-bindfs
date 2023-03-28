# shellcheck shell=bash
# shellcheck disable=SC2034
if [ ! "$_bindfs_INCLUDED_" = "1" ]; then
_bindfs_INCLUDED_=1

# NOTE : require fuse
# 			apt-get install libfuse-dev


feature_bindfs() {
	FEAT_NAME=bindfs

	FEAT_LIST_SCHEMA="1_17_2:source 1_16_1:source 1_15_1:source 1_14_9:source 1_14_1:source 1_13_11:source 1_13_10:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"


	FEAT_DESC="Mount a directory elsewhere with changed permissions"
	FEAT_LINK="https://bindfs.org"
}




feature_bindfs_1_17_2() {
	FEAT_VERSION="1_17_2"


	FEAT_SOURCE_DEPENDENCIES="FORCE_ORIGIN_SYSTEM fuse"

	FEAT_SOURCE_URL="https://github.com/mpartel/bindfs/archive/1.17.2.tar.gz"
	FEAT_SOURCE_URL_FILENAME="bindfs-1.17.2.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_bindfs_link"

	FEAT_TEST="bindfs"
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/$FEAT_TEST"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_bindfs_1_16_1() {
	FEAT_VERSION="1_16_1"


	FEAT_SOURCE_DEPENDENCIES="FORCE_ORIGIN_SYSTEM fuse"

	FEAT_SOURCE_URL="https://github.com/mpartel/bindfs/archive/1.16.1.tar.gz"
	FEAT_SOURCE_URL_FILENAME="bindfs-1.16.1.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_bindfs_link"

	FEAT_TEST="bindfs"
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/$FEAT_TEST"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}





feature_bindfs_1_15_1() {
	FEAT_VERSION="1_15_1"


	FEAT_SOURCE_DEPENDENCIES="FORCE_ORIGIN_SYSTEM fuse"

	FEAT_SOURCE_URL="https://github.com/mpartel/bindfs/archive/1.15.1.tar.gz"
	FEAT_SOURCE_URL_FILENAME="bindfs-1.15.1.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_bindfs_link"

	FEAT_TEST="bindfs"
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/$FEAT_TEST"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}




feature_bindfs_1_14_9() {
	FEAT_VERSION="1_14_9"


	FEAT_SOURCE_DEPENDENCIES="FORCE_ORIGIN_SYSTEM fuse"

	FEAT_SOURCE_URL="https://github.com/mpartel/bindfs/archive/1.14.9.tar.gz"
	FEAT_SOURCE_URL_FILENAME="bindfs-1.14.9.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_bindfs_link"

	FEAT_TEST="bindfs"
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/$FEAT_TEST"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_bindfs_1_14_1() {
	FEAT_VERSION="1_14_1"


	FEAT_SOURCE_DEPENDENCIES="FORCE_ORIGIN_SYSTEM fuse"

	FEAT_SOURCE_URL="https://github.com/mpartel/bindfs/archive/1.14.1.tar.gz"
	FEAT_SOURCE_URL_FILENAME="bindfs-1.14.1.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	# use feature_gcc_common_flag because bindfs was fixed only starting version 14.3
	# https://github.com/mpartel/bindfs/commit/9ad6363e9c1ee463bff7f28454283dd49d0d2e20#diff-e256f784f2dbf09663e201ca14a3bfebda1aa6161d65b195fcfb729758af17cd
	FEAT_SOURCE_CALLBACK="feature_bindfs_link feature_gcc_common_flag"

	FEAT_TEST="bindfs"
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/$FEAT_TEST"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_bindfs_1_13_11() {
	FEAT_VERSION="1_13_11"


	FEAT_SOURCE_DEPENDENCIES="FORCE_ORIGIN_SYSTEM fuse"

	FEAT_SOURCE_URL="https://github.com/mpartel/bindfs/archive/1.13.11.tar.gz"
	FEAT_SOURCE_URL_FILENAME="bindfs-1.13.11.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	# use feature_gcc_common_flag because bindfs was fixed only starting version 14.3
	# https://github.com/mpartel/bindfs/commit/9ad6363e9c1ee463bff7f28454283dd49d0d2e20#diff-e256f784f2dbf09663e201ca14a3bfebda1aa6161d65b195fcfb729758af17cd
	FEAT_SOURCE_CALLBACK="feature_bindfs_link feature_gcc_common_flag"

	FEAT_TEST="bindfs"
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/$FEAT_TEST"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}

feature_gcc_common_flag() {
	# gcc10 change its default behavior from -fcommon to -fno-commo
	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=85678
	# use this flag to force old behavior
	STELLA_C_CXX_FLAGS="-fcommon"
}

feature_bindfs_link() {
	__link_feature_library "FORCE_ORIGIN_SYSTEM fuse" "USE_PKG_CONFIG"
}

feature_bindfs_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"
	__add_toolset "autotools"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"

	__feature_callback


	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD AUTOTOOLS autogen"


}


fi
