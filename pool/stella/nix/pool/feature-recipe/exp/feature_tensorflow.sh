if [ ! "$_TENSORFLOW_INCLUDED_" = "1" ]; then
_TENSORFLOW_INCLUDED_=1

# https://www.tensorflow.org/get_started/os_setup#installing_from_sources

feature_tensorflow() {
	FEAT_NAME=tensorflow

	FEAT_LIST_SCHEMA="0_11_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"


}


feature_tensorflow_0_11_0() {
	FEAT_VERSION=0_11_0

	FEAT_SOURCE_DEPENDENCIES="swig#3_0_10"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/tensorflow/tensorflow/archive/v0.11.0.tar.gz
	FEAT_SOURCE_URL_FILENAME=tensorflow-v0.11.0.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/tensorflow-0.11.0*.whl
	FEAT_SEARCH_PATH=

}


feature_tensorflow_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"
	__add_toolset "bazel#0_3_2"
	__add_toolset "miniconda"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"


	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"


	# override bazel_clean_and_fetch to not clean cache
	sed -i".old" "s/function bazel_clean_and_fetch/function override/g" "$SRC_DIR/configure"

	cd $SRC_DIR
	bazel clean --expunge
	bazel fetch //tensorflow/...

	for _p in 2 3; do
		FEAT_PYENV="$FEAT_NAME"_"$FEAT_VERSION"_PY$_p
		conda env remove -y -n $FEAT_PYENV
		conda create -y -n $FEAT_PYENV python=$_p

		source activate $FEAT_PYENV
		pip install -U protobuf=3.0.0
		pip install asciitree
		pip install numpy

		cd $SRC_DIR
		./configure
		bazel build -c opt //tensorflow/tools/pip_package:build_pip_package
		bazel-bin/tensorflow/tools/pip_package/build_pip_package "$INSTALL_DIR"

		source deactivate $FEAT_PYENV
		conda env remove -y -n $FEAT_PYENV
	done



	__end_manual_build

	__del_folder $SRC_DIR


}


fi
