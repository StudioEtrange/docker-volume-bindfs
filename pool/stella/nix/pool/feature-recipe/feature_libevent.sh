if [ ! "$_libevent_INCLUDED_" = "1" ]; then
_libevent_INCLUDED_=1

feature_libevent() {
	FEAT_NAME=libevent
	FEAT_LIST_SCHEMA="2_1_8:source 2_0_22:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}



feature_libevent_2_1_8() {
	FEAT_VERSION=2_1_8


	FEAT_SOURCE_DEPENDENCIES="openssl#1_0_2d"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
	FEAT_SOURCE_URL_FILENAME=libevent-2.1.8-stable.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_libevent_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libevent.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_libevent_2_0_22() {
	FEAT_VERSION=2_0_22


	FEAT_SOURCE_DEPENDENCIES="openssl#1_0_2d"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz
	FEAT_SOURCE_URL_FILENAME=libevent-2.0.22-stable.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_libevent_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libevent.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_libevent_link() {
	__link_feature_library "openssl#1_0_2d"
}


feature_libevent_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__set_toolset "STANDARD"

  __feature_callback

  AUTO_INSTALL_CONF_FLAG_PREFIX=
  AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking"
  AUTO_INSTALL_BUILD_FLAG_PREFIX=
  AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__set_build_mode "PARALLELIZE" "OFF"
	__set_build_mode "LINK_FLAGS_DEFAULT" "OFF"

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD SOURCE_KEEP"


}


fi
