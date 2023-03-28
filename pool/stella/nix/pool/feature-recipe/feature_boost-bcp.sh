if [ ! "$_BOOSTBCP_INCLUDED_" = "1" ]; then
_BOOSTBCP_INCLUDED_=1

# for more information see feature boost

feature_boost-bcp() {
	FEAT_NAME=boost-bcp
	FEAT_LIST_SCHEMA="1_58_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_boost-bcp_1_58_0() {
	FEAT_VERSION=1_58_0


	FEAT_SOURCE_DEPENDENCIES="boost-build"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://downloads.sourceforge.net/project/boost/boost/1.58.0/boost_1_58_0.tar.bz2
	FEAT_SOURCE_URL_FILENAME=boost_1_58_0.tar.bz2
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/bcp
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_boost-bcp_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"


	cd "$SRC_DIR/tools/bcp"

	b2 -d2 -j$STELLA_NB_CPU

	mkdir -p "$INSTALL_DIR/bin"
  cp -f "$SRC_DIR/dist/bin/bcp" "$INSTALL_DIR/bin/"

	__del_folder "$SRC_DIR"

	__end_manual_build


}


fi
