if [ ! "$_NUCTL_INCLUDED_" = "1" ]; then
_NUCTL_INCLUDED_=1


feature_nuctl() {
	FEAT_NAME="nuctl"
	FEAT_LIST_SCHEMA="1_6_27@x64:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Nuclio command-line interface"
	FEAT_LINK="https://github.com/nuclio/nuclio"
}




feature_nuctl_1_6_27() {


	FEAT_VERSION="1_6_27"

	# Properties for BINARY flavour

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/nuclio/nuclio/releases/download/1.6.27/nuctl-1.6.27-darwin-amd64"
		FEAT_BINARY_URL_FILENAME_x64="nuctl-1.6.27-darwin-amd64"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/nuclio/nuclio/releases/download/1.6.27/nuctl-1.6.27-linux-amd64"
		FEAT_BINARY_URL_FILENAME_x64="nuctl-1.6.27-linux-amd64"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi


	# List of files to test if feature is installed
	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/nuctl"
	# PATH to add to system PATH
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}





feature_nuctl_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE FORCE_NAME $FEAT_BINARY_URL_FILENAME"

	mv "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" "${FEAT_INSTALL_ROOT}/nuctl"
	chmod +x "${FEAT_INSTALL_ROOT}/nuctl"
}





fi
