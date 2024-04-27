if [ ! "$_dust_INCLUDED_" = "1" ]; then
_dust_INCLUDED_=1

# NOTE : require GLIBC_2.18

feature_dust() {
	FEAT_NAME="dust"
	FEAT_LIST_SCHEMA="1_0_0@x64:binary 1_0_0@x86:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="A more intuitive version of du in rust"
	FEAT_LINK="https://github.com/bootandy/dust"
}




feature_dust_1_0_0() {

	FEAT_VERSION="1_0_0"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/bootandy/dust/releases/download/v1.0.0/dust-v1.0.0-x86_64-unknown-linux-gnu.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="dust-v1.0.0-x86_64-unknown-linux-gnu.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		FEAT_BINARY_URL_x86="https://github.com/bootandy/dust/releases/download/v1.0.0/dust-v1.0.0-i686-unknown-linux-gnu.tar.gz"
		FEAT_BINARY_URL_FILENAME_x86="dust-v1.0.0-i686-unknown-linux-gnu.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
	fi

	# List of files to test if feature is installed
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/dust"
	# PATH to add to system PATH
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}



feature_dust_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"


}




fi
