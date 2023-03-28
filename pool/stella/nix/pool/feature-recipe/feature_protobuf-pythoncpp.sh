if [ ! "$_protobufpythoncpp_INCLUDED_" = "1" ]; then
_protobufpythoncpp_INCLUDED_=1


feature_protobuf-pythoncpp() {
	FEAT_NAME=protobuf-pythoncpp

	FEAT_LIST_SCHEMA="3_1_0:source 3_0_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"


}

feature_protobuf-pythoncpp_3_1_0() {
	FEAT_VERSION=3_1_0


	FEAT_SOURCE_DEPENDENCIES="protobuf#3_1_0"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/google/protobuf/archive/v3.1.0.tar.gz
	FEAT_SOURCE_URL_FILENAME=protobuf-pythoncpp-3_1_0.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_protobuf-pythoncpp_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/protobuf-3.1.0*.whl
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_protobuf-pythoncpp_3_0_0() {
	FEAT_VERSION=3_0_0


	FEAT_SOURCE_DEPENDENCIES="protobuf#3_0_0"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/google/protobuf/archive/v3.0.0.tar.gz
	FEAT_SOURCE_URL_FILENAME=protobuf-pythoncpp-3_0_0.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_protobuf-pythoncpp_dep_gmock1_7_0 feature_protobuf-pythoncpp_link"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/protobuf-3.0.0*.whl
	FEAT_SEARCH_PATH=

}

# need for old version which have a broken gmock link
feature_protobuf-pythoncpp_dep_gmock1_7_0() {
	__get_resource "gmock" "https://github.com/google/googletest/archive/release-1.7.0.tar.gz" "HTTP_ZIP" "$SRC_DIR/gmock" "DEST_ERASE STRIP FORCE_NAME gmock-release-1.7.0.tar.gz"
}

feature_protobuf-pythoncpp_link() {
	__link_feature_library "protobuf#$FEAT_VERSION" "GET_FOLDER _protobuf"
	ln -s $_protobuf_ROOT/lib $SRC_DIR/src/.libs
}

feature_protobuf-pythoncpp_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"
	__add_toolset "miniconda"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"



	__feature_callback

	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

	# PYTHON3
	cd $SRC_DIR/python
	FEAT_PYENV="$FEAT_NAME"_"$FEAT_VERSION"_PY3
	conda env remove -y -n $FEAT_PYENV
	conda create -y -n $FEAT_PYENV python=3

	source activate $FEAT_PYENV
	PROTOC=$_protobuf_ROOT/bin/protoc python setup.py bdist_wheel --cpp_implementation --compile_static_extension
	source deactivate $FEAT_PYENV
	conda env remove -y -n $FEAT_PYENV

	# PYTHON2
	FEAT_PYENV="$FEAT_NAME"_"$FEAT_VERSION"_PY2
	conda env remove -y -n $FEAT_PYENV
	conda create -y -n $FEAT_PYENV python=2

	source activate $FEAT_PYENV
	PROTOC=$_protobuf_ROOT/bin/protoc python setup.py bdist_wheel --cpp_implementation --compile_static_extension
	source deactivate $FEAT_PYENV
	conda env remove -y -n $FEAT_PYENV

	__end_manual_build

	__copy_folder_content_into $SRC_DIR/python/dist $INSTALL_DIR
	__del_folder $SRC_DIR

}


fi
