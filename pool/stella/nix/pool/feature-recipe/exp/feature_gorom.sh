if [ ! "$_TEMPLATEGO_INCLUDED_" = "1" ]; then
_gorom_INCLUDED_=1

# DO NOT WORK
# miss libsciter


feature_gorom() {
	FEAT_NAME="gorom"
	FEAT_LIST_SCHEMA="0_1_2:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="GoROM is a utility to manage emulator ROM files"
	FEAT_LINK="https://github.com/shumatech/gorom"
}


feature_gorom_0_1_2() {
	FEAT_VERSION="0_1_2"
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/shumatech/gorom/archive/refs/tags/v0.1.2.tar.gz"
	FEAT_SOURCE_URL_FILENAME="master.zip"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/gorom"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_gorom_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$FEAT_INSTALL_ROOT/src"
	BUILD_DIR=

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__set_toolset "STANDARD"
	__add_toolset "go#1_17_5"

	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

	cd "$SRC_DIR"
	make Darwin
	make install
	__end_manual_build

}

fi
