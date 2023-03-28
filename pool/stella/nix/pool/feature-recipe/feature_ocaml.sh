if [ ! "$_ocaml_INCLUDED_" = "1" ]; then
_ocaml_INCLUDED_=1

# https://github.com/Homebrew/homebrew-core/blob/master/Formula/ocaml.rb

feature_ocaml() {
	FEAT_NAME=ocaml
	FEAT_LIST_SCHEMA="4_03_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_ocaml_4_03_0() {
	FEAT_VERSION=4_03_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://caml.inria.fr/pub/distrib/ocaml-4.03/ocaml-4.03.0.tar.gz
	FEAT_SOURCE_URL_FILENAME=ocaml-4.03.0.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/ocaml
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_ocaml_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback
	#__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

	[ "$STELLA_CURRENT_OS" = "macos" ] && __set_build_mode "MACOSX_DEPLOYMENT_TARGET" ""

	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"


	cd "$SRC_DIR"
	./configure --prefix "$INSTALL_DIR" -no-graph -flambda

	make world.opt
	#make -j$STELLA_NB_CPU install
	make install
	__del_folder $SRC_DIR

	__end_manual_build

}



fi
