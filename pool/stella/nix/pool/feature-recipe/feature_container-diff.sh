if [ ! "$_containerdiff_INCLUDED_" = "1" ]; then
_containerdiff_INCLUDED_=1

feature_container-diff() {
	FEAT_NAME=container-diff
	FEAT_LIST_SCHEMA="0_17_0x64:binary"
	FEAT_DEFAULT_ARCH=x64
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Diff your Docker containers, analysing filesystem, rpm and pip packages and so on..."
	FEAT_LINK="https://github.com/GoogleContainerTools/container-diff"
}


feature_container-diff_0_17_0() {
	FEAT_VERSION=0_17_0

	# Properties for BINARY flavour
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/GoogleContainerTools/container-diff/releases/download/v0.17.0/container-diff-darwin-amd64"
		FEAT_BINARY_URL_FILENAME_x64="container-diff-darwin-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/GoogleContainerTools/container-diff/releases/download/v0.17.0/container-diff-linux-amd64"
		FEAT_BINARY_URL_FILENAME_x64="container-diff-linux-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi


	# List of files to test if feature is installed
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/container-diff"
	# PATH to add to system PATH
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_container-diff_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE FORCE_NAME $FEAT_BINARY_URL_FILENAME"
	mv -f "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME" "$FEAT_INSTALL_ROOT/container-diff"
	chmod +x "$FEAT_INSTALL_ROOT/container-diff"

}



fi
