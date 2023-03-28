if [ ! "$_cointop_INCLUDED_" = "1" ]; then
_cointop_INCLUDED_=1


feature_cointop() {
	FEAT_NAME=cointop
	FEAT_LIST_SCHEMA="1_1_4:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="The fastest and most interactive terminal based UI application for tracking cryptocurrencies "
	FEAT_LINK="https://cointop.sh"
}


feature_cointop_1_1_4() {
	FEAT_VERSION=1_1_4


	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL="https://github.com/miguelmota/cointop/releases/download/1.1.4/cointop_1.1.4_linux_amd64.tar.gz"
		FEAT_BINARY_URL_FILENAME="cointop_1.1.4_linux_amd64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://github.com/miguelmota/cointop/releases/download/1.1.4/cointop_1.1.4_darwin_amd64.tar.gz"
		FEAT_BINARY_URL_FILENAME="cointop_1.1.4_darwin_amd64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"
	fi


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/cointop
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}



feature_cointop_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT"

	#mv "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME" "$FEAT_INSTALL_ROOT/cointop"
	#chmod +x $FEAT_INSTALL_ROOT/cointop
}


fi
