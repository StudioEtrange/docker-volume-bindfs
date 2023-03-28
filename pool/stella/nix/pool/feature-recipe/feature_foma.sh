if [ ! "$_FOMA_INCLUDED_" = "1" ]; then
_FOMA_INCLUDED_=1



feature_foma() {
	FEAT_NAME=foma
	FEAT_LIST_SCHEMA="0_9_18:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}

feature_foma_0_9_18() {
	FEAT_VERSION=0_9_18

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://bitbucket.org/mhulden/foma/downloads/foma-0.9.18_OSX.tar.gz
		FEAT_BINARY_URL_FILENAME=foma-0.9.18_OSX.tar.gz
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://bitbucket.org/mhulden/foma/downloads/foma-0.9.18_linux64.tar.gz
		FEAT_BINARY_URL_FILENAME=foma-0.9.18_linux64.tar.gz
	fi
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/foma
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_foma_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"

}


fi
