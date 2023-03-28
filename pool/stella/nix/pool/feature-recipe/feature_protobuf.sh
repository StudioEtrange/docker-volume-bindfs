if [ ! "$_protobuf_INCLUDED_" = "1" ]; then
_protobuf_INCLUDED_=1


feature_protobuf() {
	FEAT_NAME=protobuf

	FEAT_LIST_SCHEMA="3_1_0:source 3_0_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"


}

feature_protobuf_3_1_0() {
	FEAT_VERSION=3_1_0


	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/google/protobuf/archive/v3.1.0.tar.gz
	FEAT_SOURCE_URL_FILENAME=protobuf-3_1_0.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/protoc
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_protobuf_3_0_0() {
	FEAT_VERSION=3_0_0


	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/google/protobuf/archive/v3.0.0.tar.gz
	FEAT_SOURCE_URL_FILENAME=protobuf-3_0_0.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_protobuf_dep_gmock1_7_0
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/protoc
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

# need for old version which have a broken gmock link
feature_protobuf_dep_gmock1_7_0() {
	__get_resource "gmock" "https://github.com/google/googletest/archive/release-1.7.0.tar.gz" "HTTP_ZIP" "$SRC_DIR/gmock" "DEST_ERASE STRIP FORCE_NAME gmock-release-1.7.0.tar.gz"
}

feature_protobuf_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"
	__add_toolset "autotools"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"

	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD AUTOTOOLS autogen"


}


fi
