if [ ! "$_swig_INCLUDED_" = "1" ]; then
_swig_INCLUDED_=1


feature_swig() {
	FEAT_NAME=swig
	FEAT_LIST_SCHEMA="3_0_10:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_swig_3_0_10() {
	FEAT_VERSION=3_0_10

	FEAT_SOURCE_DEPENDENCIES="pcre#8_36"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://downloads.sourceforge.net/project/swig/swig/swig-3.0.10/swig-3.0.10.tar.gz
	FEAT_SOURCE_URL_FILENAME=swig-3.0.10.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_swig_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/swig
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_swig_link() {
	__link_feature_library "pcre#8_36" "GET_FOLDER _pcre NO_SET_FLAGS"
}


feature_swig_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking --with-pcre-prefix=$_pcre_ROOT"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "EXCLUDE_FILTER share"

}



fi
