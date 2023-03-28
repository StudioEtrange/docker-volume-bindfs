if [ ! "$_pv_INCLUDED_" = "1" ]; then
_pv_INCLUDED_=1


# http://www.ivarch.com/programs/pv.shtml
# https://github.com/icetee/pv
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/pv.rb

feature_pv() {
	FEAT_NAME=pv
	FEAT_LIST_SCHEMA="1_6_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_pv_1_6_0() {
	FEAT_VERSION=1_6_0


	FEAT_SOURCE_DEPENDENCIES="gettext#0_19_4"
	FEAT_BINARY_DEPENDENCIES=
	FEAT_SOURCE_URL=http://www.ivarch.com/programs/sources/pv-1.6.0.tar.gz
	FEAT_SOURCE_URL_FILENAME=pv-1.6.0.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_pv_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/pv
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_pv_link() {
	__link_feature_library "gettext"
}


feature_pv_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-debug"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "EXCLUDE_FILTER /share/"

}


fi
