if [ ! "$_graphviz_INCLUDED_" = "1" ]; then
_graphviz_INCLUDED_=1

# NOTE : dependencies http://www.graphviz.org/Download_source.php

feature_graphviz() {
	FEAT_NAME=graphviz

	FEAT_LIST_SCHEMA="2_40_1:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"


}

feature_graphviz_2_40_1() {
	FEAT_VERSION=2_40_1


	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2 libpng#1_6_17 freetype#2_6_1"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.40.1.tar.gz
	FEAT_SOURCE_URL_FILENAME=graphviz-2.40.1.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_graphviz_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/dot
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_graphviz_link() {
	__link_feature_library "zlib#^1_2"
	__link_feature_library "libpng#1_6_17"
	__link_feature_library "freetype#2_6_1" "GET_FOLDER _freetype NO_SET_FLAGS"
	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --with-freetypeincludedir=$_freetype_INCLUDE --with-freetypelibdir=$_freetype_LIB"

}


feature_graphviz_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback


	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"


}


fi
