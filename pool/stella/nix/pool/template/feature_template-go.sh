if [ ! "$_TEMPLATEGO_INCLUDED_" = "1" ]; then
_TEMPLATEGO_INCLUDED_=1


# note : see other example with feature_reg

feature_template-go() {
	FEAT_NAME="template-go"
	FEAT_LIST_SCHEMA="snapshot:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="template is foo"
	FEAT_LINK="https://github.com/bar/template"
}


feature_template-go_snapshot() {
	FEAT_VERSION="snapshot"
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/pborman/getopt/archive/master.zip"
	FEAT_SOURCE_URL_FILENAME="master.zip"
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/getopt"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_template-go_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$FEAT_INSTALL_ROOT/src"
	BUILD_DIR=

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__add_toolset "go-build-chain#1_5_3"

	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"


	# get all dependencies
	cd "$SRC_DIR"
	cd Godeps
	# with godep
	GOPATH="$INSTALL_DIR" godep restore

	GOPATH="$INSTALL_DIR" go install product

	__end_manual_build

}

fi
