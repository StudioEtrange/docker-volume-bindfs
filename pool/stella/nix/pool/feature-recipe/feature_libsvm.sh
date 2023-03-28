if [ ! "$_libsvm_INCLUDED_" = "1" ]; then
_libsvm_INCLUDED_=1

# https://www.csie.ntu.edu.tw/~cjlin/

feature_libsvm() {
	FEAT_NAME=libsvm

	FEAT_LIST_SCHEMA="3_2_1:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"


}

feature_libsvm_3_2_1() {
	FEAT_VERSION=3_2_1

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/cjlin1/libsvm/archive/v321.tar.gz
	FEAT_SOURCE_URL_FILENAME=libsvm-v321.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/svm-train
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_libsvm_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"



	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"

	__set_toolset "STANDARD"

	__feature_callback



	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD NO_CONFIG SOURCE_KEEP NO_INSTALL"

	# build python lib
	__auto_build "$FEAT_NAME" "$SRC_DIR/python" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD NO_CONFIG SOURCE_KEEP NO_INSTALL"

	# build java
	# NOTE : jar is already built into source folder
	#__auto_build "$FEAT_NAME" "$SRC_DIR/java" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD NO_CONFIG SOURCE_KEEP NO_INSTALL"

	__copy_folder_content_into "$SRC_DIR" "$INSTALL_DIR"

	__del_folder "$SRC_DIR"

	__inspect_and_fix_build "$INSTALL_DIR"

}


fi
