if [ ! "$_NGINX_INCLUDED_" = "1" ]; then
_NGINX_INCLUDED_=1


# NOTE : build from source depend on zlib, openssl, pcre
# for zlib and openssl : will use system installed version OR built by nginx makefile (see auto/options file : --with-zlib=SOURCE_DIR --with-openssl=SOURCE_DIR)
# for pcre : built by nginx makefile (see auto/options file : --with-pcre=SOURCE_DIR)

feature_nginx() {
	FEAT_NAME=nginx
	FEAT_LIST_SCHEMA="1_7_11:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_nginx_1_7_11() {
	FEAT_VERSION=1_7_11

	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2 openssl#1_0_2d"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://nginx.org/download/nginx-1.7.11.tar.gz
	FEAT_SOURCE_URL_FILENAME=nginx-1.7.11.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_nginx_link feature_nginx_get_pcre"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/sbin/nginx
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/sbin

}

feature_nginx_link() {
	__link_feature_library "openssl#1_0_2d"
	__link_feature_library "zlib#^1_2"
}


feature_nginx_get_pcre() {
	# depend on pcre, but nginx have its own way of building it
	__download_uncompress "https://downloads.sourceforge.net/project/pcre/pcre/8.36/pcre-8.36.tar.bz2" "pcre-8.36.tar.bz2" "$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src/pcre/pcre-8_36-src" "DEST_ERASE STRIP"

	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --with-pcre=$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src/pcre/pcre-8_36-src"
}

feature_nginx_install_source() {

	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src/nginx"


	#__set_toolset "CUSTOM"  "CONFIG_TOOL configure BUILD_TOOL make"
	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	#AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	# out of tree build do not work
	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD"

	rm -Rf "$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"
}


fi
