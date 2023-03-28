if [ ! "$_bison_INCLUDED_" = "1" ]; then
_bison_INCLUDED_=1


# https://github.com/Homebrew/homebrew-core/blob/master/Formula/bison.rb
# https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/tools/parsing/bison


feature_bison() {
	FEAT_NAME=bison

	FEAT_LIST_SCHEMA="3_0_4:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_LINK="https://www.gnu.org/software/bison/"
	FEAT_DESC="Bison is a general-purpose parser generator"
}

feature_bison_3_0_4() {
	FEAT_VERSION=3_0_4

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://ftp.gnu.org/gnu/bison/bison-3.0.4.tar.gz
	FEAT_SOURCE_URL_FILENAME=bison-3.0.4.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/bison
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_bison_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"
	__add_toolset "autotools"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD"
	# Tests are very very long, but works
	#__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD POST_BUILD_STEP check"
}


fi
