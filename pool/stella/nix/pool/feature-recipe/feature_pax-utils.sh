if [ ! "_paxutils_INCLUDED_" = "1" ]; then
_paxutils_INCLUDED_=1

# https://gitweb.gentoo.org/proj/pax-utils.git
# https://github.com/gentoo/pax-utils/

feature_pax-utils() {
	FEAT_NAME=pax-utils
	FEAT_LIST_SCHEMA="1_1_6:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_pax-utils_1_1_6() {
	FEAT_VERSION=1_1_6

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/gentoo/pax-utils/archive/v1.1.6.tar.gz
	FEAT_SOURCE_URL_FILENAME=pax-utils-v1.1.6.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/scanelf
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_pax-utils_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "FORCE_NAME $FEAT_SOURCE_URL_FILENAME DEST_ERASE STRIP"



	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking"
	AUTO_INSTALL_BUILD_FLAG_PREFIX="MANDIR=$INSTALL_DIR"
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	# NOTE : install man page trough an error during build -- just ignore it
	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_CONFIG"



}


fi
