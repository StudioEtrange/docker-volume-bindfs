if [ ! "$_ntopng_INCLUDED_" = "1" ]; then
_ntopng_INCLUDED_=1

# https://github.com/Homebrew/homebrew-core/blob/master/Formula/ntopng.rb

# TODO
# see Makefile for missing dependencies AND https://github.com/ntop/ntopng/tree/dev/third-party
# TODO need RRDTOOL rrdtool-1.4.8
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/rrdtool.rb
# and need a lot of others


feature_ntopng() {
	FEAT_NAME=ntopng

	FEAT_LIST_SCHEMA="SNAPSHOT:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_ntopng_SNAPSHOT() {
	FEAT_VERSION=SNAPSHOT


	FEAT_SOURCE_DEPENDENCIES="ndpi#SNAPSHOT"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/ntop/ntopng.git
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=GIT

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_ntopng_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libzmq.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

	FEAT_GIT_TAG="master"

}


feature_ntopng_link() {
	__link_feature_library "ndpi#SNAPSHOT" "NO_SET_FLAGS USE_PKG_CONFIG"
	# see Makefile for missing dependencies AND https://github.com/ntop/ntopng/tree/dev/third-party
	# TODO need RRDTOOL rrdtool-1.4.8
	# https://github.com/Homebrew/homebrew-core/blob/master/Formula/rrdtool.rb
	# and need a lot of others
}


feature_ntopng_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"
	__add_toolset "autotools"
	__add_toolset "pkgconfig"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE VERSION $FEAT_GIT_TAG"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD AUTOTOOLS autogen SOURCE_KEEP"


	#__del_folder "$SRC_DIR"
}

fi
