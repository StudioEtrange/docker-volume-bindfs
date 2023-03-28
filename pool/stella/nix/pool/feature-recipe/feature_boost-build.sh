if [ ! "$_BOOSTBUILD_INCLUDED_" = "1" ]; then
_BOOSTBUILD_INCLUDED_=1

# http://www.boost.org/build/
# tool to build c++ project

feature_boost-build() {
	FEAT_NAME=boost-build
	FEAT_LIST_SCHEMA="2014_10:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_boost-build_2014_10() {
	FEAT_VERSION=2014_10

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/boostorg/build/archive/2014.10.zip
	FEAT_SOURCE_URL_FILENAME=boost-build-src-2014.10.zip
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/bjam
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_boost-build_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"

	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

	cd $SRC_DIR
	./bootstrap.sh
  ./b2 --prefix="$INSTALL_DIR" install

  __del_folder "$SRC_DIR"

	__end_manual_build

}


fi
