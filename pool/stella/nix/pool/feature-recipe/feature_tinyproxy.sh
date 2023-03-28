if [ ! "$_tinyproxy_INCLUDED_" = "1" ]; then
_tinyproxy_INCLUDED_=1

# https://github.com/tinyproxy/tinyproxy
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/tinyproxy.rb

# NOTE : version 1.8.4 could not be built on darwin. It need to many dependencies


# Quick Usage :
# edit etc/tinyproxy.cond, comment Allow 127.0.0.1 to authorize any IP
# ./stella.sh boot cmd local -- tinyproxy -d

feature_tinyproxy() {
	FEAT_NAME=tinyproxy
	FEAT_LIST_SCHEMA="SNAPSHOT:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}


feature_tinyproxy_SNAPSHOT() {
	FEAT_VERSION=SNAPSHOT
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/tinyproxy/tinyproxy
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=GIT

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/sbin/tinyproxy
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/sbin

}



feature_tinyproxy_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"
	__add_toolset "autotools"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	# --enable-xtinyproxy     Include the X-Tinyproxy header (default is YES)
  # --enable-filter         Enable filtering of domains/URLS (default is YES)
  # --enable-upstream       Enable upstream proxying (default is YES)
  # --enable-reverse        Enable reverse proxying (default is NO)
  # --enable-transparent    Enable transparent proxying code (default is NO)


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking --enable-xtinyproxy --enable-filter --enable-upstream \
	--enable-reverse --enable-transparent \
	--sysconfdir=$INSTALL_DIR/etc --localstatedir=$INSTALL_DIR/var"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	mkdir -p $INSTALL_DIR/etc/tinyproxy
	mkdir -p $INSTALL_DIR/var/log/tinyproxy
	mkdir -p $INSTALL_DIR/var/run/tinyproxy

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "AUTOTOOLS autogen"


}



fi
