if [ ! "$_redis_INCLUDED_" = "1" ]; then
_redis_INCLUDED_=1


# TODO : openssl dependencies ?

feature_redis() {
	FEAT_NAME=redis
	FEAT_LIST_SCHEMA="4_0_8:source 3_0_7:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}





feature_redis_4_0_8() {
	FEAT_VERSION=4_0_8


	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://download.redis.io/releases/redis-4.0.8.tar.gz
	FEAT_SOURCE_URL_FILENAME=redis-4.0.8.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/redis-server
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_redis_3_0_7() {
	FEAT_VERSION=3_0_7


	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://download.redis.io/releases/redis-3.0.7.tar.gz
	FEAT_SOURCE_URL_FILENAME=redis-3.0.7.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/redis-server
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_redis_link() {
	__link_feature_library "openssl#1_0_2d" "LIBS_NAME ssl crypto GET_FLAGS _openssl NO_SET_FLAGS"
	sed -i .bak "s,\(-std=c99 -Wall -O2 -D_REENTRANT\),\1 $_openssl_CPP_FLAGS," "$SRC_DIR/Makefile"
	sed -i .bak "s,\(-lpthread -lm -lcrypto -lssl\),-lpthread -lm $_openssl_LINK_FLAGS," "$SRC_DIR/Makefile"
}


feature_redis_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__set_toolset "STANDARD"

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_CONFIG SOURCE_KEEP"

	__copy_folder_content_into "$SRC_DIR" "$INSTALL_DIR"

	rm -Rf "$INSTALL_DIR/deps"
	rm -Rf "$INSTALL_DIR/src"
	rm -Rf "$SRC_DIR"

}


fi
