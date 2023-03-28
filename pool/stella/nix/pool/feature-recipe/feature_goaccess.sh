if [ ! "$_goaccess_INCLUDED_" = "1" ]; then
_goaccess_INCLUDED_=1


feature_goaccess() {
	FEAT_NAME=goaccess

	FEAT_LIST_SCHEMA="1_0_1:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"


}

feature_goaccess_1_0_1() {
	FEAT_VERSION=1_0_1


	FEAT_SOURCE_DEPENDENCIES="geoip#1_6_9 ncurses#6_0"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://tar.goaccess.io/goaccess-1.0.1.tar.gz
	FEAT_SOURCE_URL_FILENAME=goaccess-1.0.1.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_SOURCE_CALLBACK="feature_goaccess_patch_1_0_1 feature_goaccess_link"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_SOURCE_CALLBACK="feature_goaccess_link"
	fi
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/goaccess
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_goaccess_patch_1_0_1() {
	# _open_memstream undefined
	# see https://github.com/allinurl/goaccess/issues/422
	# open_memstream implementation for bsd http://piumarta.com/software/memstream/
	__get_resource "memstream" "http://piumarta.com/software/memstream/memstream-0.1.tar.gz" "HTTP_ZIP" "$SRC_DIR/memstream" "STRIP"

	cp "$SRC_DIR/memstream/memstream.c" "$SRC_DIR/src"
	cp "$SRC_DIR/memstream/memstream.h" "$SRC_DIR/src"

	sed -i'.bak' 's,#include "json.h",#include "json.h"\'$'\n#include "memstream.h",' "$SRC_DIR"/src/json.c
	# sed : http://stackoverflow.com/a/11163357
	sed -i'.bak' 's,src/json.h,src/json.h \\ \'$'\n''src/memstream.c \\ \'$'\n''src/memstream.h,' "$SRC_DIR"/Makefile.am
}

feature_goaccess_link() {
	__link_feature_library "geoip#1_6_9"
	__link_feature_library "ncurses#6_0"
}

feature_goaccess_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"
	__add_toolset "autotools"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--with-getline --enable-geoip --enable-utf8  --disable-dependency-tracking --disable-debug"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "AUTOTOOLS autoreconf NO_OUT_OF_TREE_BUILD"


}


fi
