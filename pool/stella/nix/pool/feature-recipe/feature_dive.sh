if [ ! "$_dive_INCLUDED_" = "1" ]; then
_dive_INCLUDED_=1


feature_dive() {
	FEAT_NAME="dive"
	FEAT_LIST_SCHEMA="0_11_0@x64:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="A tool for exploring each layer in a docker image"
	FEAT_LINK="https://github.com/wagoodman/dive"
}


feature_dive_0_11_0() {
	FEAT_VERSION="0_11_0"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/wagoodman/dive/releases/download/v0.11.0/dive_0.11.0_linux_amd64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="dive_0.11.0_linux_amd64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/wagoodman/dive/releases/download/v0.11.0/dive_0.11.0_darwin_amd64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="dive_0.11.0_darwin_amd64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/dive"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}


feature_dive_install_binary() {

	__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE FORCE_NAME $FEAT_BINARY_URL_FILENAME"

}


fi
