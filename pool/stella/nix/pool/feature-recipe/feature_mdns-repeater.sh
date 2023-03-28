if [ ! "$_mdnsrepeater_INCLUDED_" = "1" ]; then
_mdnsrepeater_INCLUDED_=1


feature_mdns-repeater() {
	FEAT_NAME=mdns-repeater
	FEAT_LIST_SCHEMA="SNAPSHOT:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}



feature_mdns-repeater_SNAPSHOT() {
	FEAT_VERSION=SNAPSHOT

	# Dependencies
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	# Properties for SOURCE flavour
	FEAT_SOURCE_URL=https://bitbucket.org/geekman/mdns-repeater
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=HG

	# Properties for BINARY flavour
	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	# callback are list of functions
	# manual callback (with feature_callback)
	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	# automatic callback each time feature is initialized, to init env var
	FEAT_ENV_CALLBACK=

	# List of files to test if feature is installed
	FEAT_INSTALL_TEST=$FEAT_INSTALL_ROOT/mdns-repeater
	# PATH to add to system PATH
	FEAT_SEARCH_PATH=$FEAT_INSTALL_ROOT

}


feature_mdns-repeater_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD NO_CONFIG NO_INSTALL SOURCE_KEEP"

	mv "$SRC_DIR/mdns-repeater" "$INSTALL_DIR/"
	__copy_folder_content_into "$SRC_DIR" "$INSTALL_DIR" "*.txt"

	__del_folder $SRC_DIR

}




fi
