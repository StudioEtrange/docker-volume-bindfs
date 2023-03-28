if [ ! "$_RCLONE_INCLUDED_" = "1" ]; then
_RCLONE_INCLUDED_=1



feature_rclone() {

	FEAT_NAME="rclone"
	[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && FEAT_LIST_SCHEMA="1_54_0@x64:binary"
	[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && FEAT_LIST_SCHEMA="1_54_0@x64:binary 1_54_0@x86:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	
	FEAT_DESC="Rclone rsync for cloud storage is a command line program to sync files and directories to and from different cloud storage providers."
	FEAT_LINK="https://github.com/rclone/rclone"
}

feature_rclone_1_54_0() {
	FEAT_VERSION="1_54_0"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/rclone/rclone/releases/download/v1.54.0/rclone-v1.54.0-osx-amd64.zip"
		FEAT_BINARY_URL_FILENAME_x64="rclone-v1.54.0-osx-amd64.zip"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/rclone/rclone/releases/download/v1.54.0/rclone-v1.54.0-linux-amd64.zip"
		FEAT_BINARY_URL_FILENAME_x64="rclone-v1.54.0-linux-amd64.zip"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		FEAT_BINARY_URL_x86="https://github.com/rclone/rclone/releases/download/v1.54.0/rclone-v1.54.0-linux-386.zip"
		FEAT_BINARY_URL_FILENAME_x86="rclone-v1.54.0-linux-386.zip"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/rclone
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}

# -----------------------------------------
feature_rclone_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"
}

fi
