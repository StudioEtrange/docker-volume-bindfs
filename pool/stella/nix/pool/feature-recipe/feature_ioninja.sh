if [ ! "$_ioninja_INCLUDED_" = "1" ]; then
_ioninja_INCLUDED_=1



feature_ioninja() {
	FEAT_NAME=ioninja
	FEAT_LIST_SCHEMA="3_6_5:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}



feature_ioninja_3_6_5() {
	FEAT_VERSION=3_6_5

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=http://tibbo.com/downloads/archive/ioninja/ioninja-3.6.5/ioninja-mac-3.6.5.tar.xz
		FEAT_BINARY_URL_FILENAME=ioninja-mac-3.6.5.tar.xz
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=http://tibbo.com/downloads/archive/ioninja/ioninja-3.6.5/ioninja-linux-3.6.5-amd64.tar.xz
		FEAT_BINARY_URL_FILENAME=ioninja-linux-3.6.5-amd64.tar.xz
	fi
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/ioninja
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_ioninja_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE"
}


fi
