if [ ! "$_wrk_INCLUDED_" = "1" ]; then
_wrk_INCLUDED_=1


# NOTE : embed his own version of luajit

feature_wrk() {
	FEAT_NAME=wrk
	FEAT_LIST_SCHEMA="4_0_1:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_wrk_4_0_1() {
	FEAT_VERSION=4_0_1


	FEAT_SOURCE_DEPENDENCIES="openssl#1_0_2d"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/wg/wrk/archive/4.0.1.tar.gz
	FEAT_SOURCE_URL_FILENAME=wrk-4.0.1.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_wrk_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/wrk
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_wrk_link() {
	__link_feature_library "openssl#1_0_2d" "LIBS_NAME ssl crypto GET_FLAGS _openssl NO_SET_FLAGS"
	sed -i .bak "s,\(-std=c99 -Wall -O2 -D_REENTRANT\),\1 $_openssl_CPP_FLAGS," "$SRC_DIR/Makefile"
	sed -i .bak "s,\(-lpthread -lm -lcrypto -lssl\),-lpthread -lm $_openssl_LINK_FLAGS," "$SRC_DIR/Makefile"
}


feature_wrk_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__set_toolset "STANDARD"

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_CONFIG NO_INSTALL SOURCE_KEEP"

	cp "$SRC_DIR/wrk" "$INSTALL_DIR/"

	__inspect_and_fix_build "$INSTALL_DIR/"

	rm -Rf "$SRC_DIR"

}


fi
