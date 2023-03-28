if [ ! "$_LAZYDOCKER_INCLUDED_" = "1" ]; then
_LAZYDOCKER_INCLUDED_=1


feature_lazydocker() {
	FEAT_NAME="lazydocker"
	FEAT_LIST_SCHEMA="0_12@x64:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="A simple terminal UI for both docker and docker-compose, written in Go with the gocui library."
	FEAT_LINK="https://github.com/jesseduffield/lazydocker"
}




feature_lazydocker_0_12() {


	FEAT_VERSION="0_12"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/jesseduffield/lazydocker/releases/download/v0.12/lazydocker_0.12_Darwin_x86_64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="lazydocker_0.12_Darwin_x86_64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/jesseduffield/lazydocker/releases/download/v0.12/lazydocker_0.12_Linux_x86_64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="lazydocker_0.12_Linux_x86_64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	# List of files to test if feature is installed
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/lazydocker"
	# PATH to add to system PATH
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}



feature_lazydocker_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE FORCE_NAME $FEAT_BINARY_URL_FILENAME"

}








fi
