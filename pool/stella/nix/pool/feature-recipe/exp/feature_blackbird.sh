if [ ! "$_blackbird_INCLUDED_" = "1" ]; then
_blackbird_INCLUDED_=1

# TODO NEED OPENSSL

feature_blackbird() {
	FEAT_NAME=blackbird
	FEAT_LIST_SCHEMA="SNAPSHOT:source"
	FEAT_DEFAULT_ARCH=x64
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="Blackbird Bitcoin Arbitrage: a long/short market-neutral strategy"
	FEAT_LINK="https://github.com/butor/blackbird"
}




feature_blackbird_SNAPSHOT() {
	FEAT_VERSION=SNAPSHOT

	FEAT_SOURCE_DEPENDENCIES="jansson#2_11 sqlite#3_23_1"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/butor/blackbird"
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL="GIT"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=


	FEAT_SOURCE_CALLBACK=feature_blackbird_link
	FEAT_BINARY_CALLBACK=

	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST=$FEAT_INSTALL_ROOT/lib/libblackbird.a
	FEAT_SEARCH_PATH=

}


feature_blackbird_link() {

	__link_feature_library "sqlite"
	__link_feature_library "jansson"

}



feature_blackbird_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "CMAKE"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_INSTALL SOURCE_KEEP BUILD_KEEP"

}




fi
