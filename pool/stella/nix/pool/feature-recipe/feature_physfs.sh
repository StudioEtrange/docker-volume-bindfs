if [ ! "$_physfs_INCLUDED_" = "1" ]; then
_physfs_INCLUDED_=1



feature_physfs() {
	FEAT_NAME=physfs
	FEAT_LIST_SCHEMA="2_0_3:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}




feature_physfs_2_0_3() {
	FEAT_VERSION=2_0_3

	FEAT_SOURCE_DEPENDENCIES="readline zlib#^1_2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://icculus.org/physfs/downloads/physfs-2.0.3.tar.bz2
	FEAT_SOURCE_URL_FILENAME=physfs-2.0.3.tar.bz2
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_physfs_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libphysfs.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_physfs_link() {
	__link_feature_library "zlib#^1_2"
	__link_feature_library "readline"
}

feature_physfs_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "CMAKE"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="-DPHYSFS_BUILD_TEST=TRUE -DPHYSFS_BUILD_WX_TEST=FALSE"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

}




fi
