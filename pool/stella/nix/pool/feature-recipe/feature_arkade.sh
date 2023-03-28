if [ ! "$_ARKADE_INCLUDED_" = "1" ]; then
_ARKADE_INCLUDED_=1


feature_arkade() {
	FEAT_NAME="arkade"
	FEAT_LIST_SCHEMA="0_8_8@x64:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="arkade provides a portable marketplace for downloading your favourite devops CLIs and installing helm charts, with a single command"
	FEAT_LINK="https://github.com/alexellis/arkade https://www.youtube.com/watch?v=8wU9s_mua8M"
}




feature_arkade_0_8_8() {


	FEAT_VERSION="0_8_8"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/alexellis/arkade/releases/download/0.8.8/arkade-darwin"
		FEAT_BINARY_URL_FILENAME_x64="arkade-darwin-${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/alexellis/arkade/releases/download/0.8.8/arkade"
		FEAT_BINARY_URL_FILENAME_x64="arkade-linux-${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi

	# List of files to test if feature is installed
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/arkade"
	# PATH to add to system PATH
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}



feature_arkade_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"
	
	if [ -f "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" ]; then
		mv "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" "${FEAT_INSTALL_ROOT}/arkade"
		chmod +x "${FEAT_INSTALL_ROOT}/arkade"
	fi

}








fi
