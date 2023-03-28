if [ ! "$_UPX_INCLUDED_" = "1" ]; then
_UPX_INCLUDED_=1

# OK

feature_upx() {
	FEAT_NAME=upx
	FEAT_LIST_SCHEMA="3_91:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_upx_3_91() {
	FEAT_VERSION=3_91

	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2 ucl#1_03"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://upx.sourceforge.net/download/upx-3.91-src.tar.bz2
	FEAT_SOURCE_URL_FILENAME=upx-3.91-src.tar.bz2
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_ucl_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/upx
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin
}


feature_ucl_link() {

	__link_feature_library "ucl#1_03" "LIBS_NAME ucl FORCE_STATIC"
	__link_feature_library "zlib#^1_2" "LIBS_NAME z FORCE_DYNAMIC"

}

feature_upx_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__feature_callback

	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"


	CXXFLAGS="$CXXFLAGS "

	# can not build doc
	sed -i".old" '/-C doc/d' "$SRC_DIR/Makefile"

	# some gcc version will fail on undeclared typedef
	sed -i".old" "s/CXXFLAGS += -Wall/CXXFLAGS += -Wall -Wno-unused-local-typedefs/g" "$SRC_DIR/src/Makefile"

	cd "$SRC_DIR"

	make all

	if [ -f "$SRC_DIR/src/upx.out" ]; then
		mkdir -p "$INSTALL_DIR/bin"
		cp "$SRC_DIR/src/upx.out" "$INSTALL_DIR/bin/upx"
		__del_folder "$SRC_DIR"
	fi

	__inspect_and_fix_build "$INSTALL_DIR"

	__end_manual_build

}



fi
