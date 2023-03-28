if [ ! "$_GETOPT_INCLUDED_" = "1" ]; then
_GETOPT_INCLUDED_=1

#https://github.com/Homebrew/homebrew/blob/master/Library/Formula/gnu-getopt.rb
# TODO : patch makefile with macport recipe ?

feature_getopt() {

	FEAT_NAME=getopt
	FEAT_LIST_SCHEMA="1_1_6:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_getopt_1_1_6() {
	FEAT_VERSION=1_1_6
	# depend on gettext ?
	FEAT_SOURCE_DEPENDENCIES="gettext#0_19_4:source"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://frodo.looijaard.name/system/files/software/getopt/getopt-1.1.6.tar.gz
	FEAT_SOURCE_URL_FILENAME=getopt-1.1.6.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_getopt_1_1_6_patch
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/getopt
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_getopt_1_1_6_patch() {
	# https://github.com/Homebrew/homebrew/blob/master/Library/Formula/gnu-getopt.rb

	__link_feature_library "gettext" "LIBS_NAME intl GET_FLAGS _gettext NO_SET_FLAGS"

	#sed -i .bak 's,^\(CPPFLAGS=.*\),\1 '"-I$FEAT_INSTALL_ROOT/include"',' $SRC_DIR/Makefile
	#sed -i .bak 's,^\(LDFLAGS=.*\),\1 '"-L$FEAT_INSTALL_ROOT/lib -lintl"',' $SRC_DIR/Makefile

	export _gettext_CPP_FLAGS="$_gettext_CPP_FLAGS"
	export _gettext_LINK_FLAGS="$_gettext_LINK_FLAGS"

	# TODO : PATCH STELLA
	sed -i .bak "s,^\(CPPFLAGS=.*\),\1 $_gettext_CPP_FLAGS," "$SRC_DIR/Makefile"
	sed -i .bak "s,^\(LDFLAGS=.*\),\1 $_gettext_LINK_FLAGS," "$SRC_DIR/Makefile"

}

feature_getopt_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	#__set_toolset "CUSTOM" "CONFIG_TOOL configure BUILD_TOOL make"
	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX="mandir=man"


	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_CONFIG"

}



fi
