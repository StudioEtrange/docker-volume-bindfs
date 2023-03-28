if [ ! "$_matchbox_INCLUDED_" = "1" ]; then
_matchbox_INCLUDED_=1




feature_matchbox() {

	FEAT_NAME=matchbox
	FEAT_LIST_SCHEMA="0_7_0:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}


feature_matchbox_0_7_0() {
	FEAT_VERSION=0_7_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://github.com/coreos/matchbox/releases/download/v0.7.0/matchbox-v0.7.0-darwin-amd64.tar.gz
		FEAT_BINARY_URL_FILENAME=matchbox-v0.7.0-darwin-amd64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://github.com/coreos/matchbox/releases/download/v0.7.0/matchbox-v0.7.0-linux-amd64.tar.gz
		FEAT_BINARY_URL_FILENAME=matchbox-v0.7.0-linux-amd64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/matchbox
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}



# -----------------------------------------
feature_matchbox_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"


}




fi
