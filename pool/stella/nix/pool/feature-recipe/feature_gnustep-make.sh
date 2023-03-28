if [ ! "$_gnustepmake_INCLUDED_" = "1" ]; then
_gnustepmake_INCLUDED_=1

feature_gnustep-make() {
	FEAT_NAME=gnustep-make

	FEAT_LIST_SCHEMA="2_6_7:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"


}

feature_gnustep-make_2_6_7() {
	FEAT_VERSION=2_6_7


	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://ftpmain.gnustep.org/pub/gnustep/core/gnustep-make-2.6.7.tar.gz
	FEAT_SOURCE_URL_FILENAME=gnustep-make-2.6.7.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=feature_gnustep-make_setenv

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/gnustep-config
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_gnustep-make_setenv() {
	source $FEAT_INSTALL_ROOT/Library/GNUstep/Makefiles/GNUstep.sh
}

feature_gnustep-make_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--with-config-file=$INSTALL_DIR/etc/GNUstep.conf --enable-native-objc-exceptions"

	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX="tooldir=$INSTALL_DIR/bin"

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"




}


fi
