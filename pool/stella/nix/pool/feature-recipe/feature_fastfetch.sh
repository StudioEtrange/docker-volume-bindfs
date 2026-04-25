if [ ! "$_fastfetch_INCLUDED_" = "1" ]; then
_fastfetch_INCLUDED_=1


feature_fastfetch() {
	FEAT_NAME="fastfetch"
	FEAT_LIST_SCHEMA="2_61_0@x64:binary 2_53_0@x64:binary 2_5_0@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Print a screen describing the system. Like neofetch, but much faster because written mostly in C"
	FEAT_LINK="https://github.com/fastfetch-cli/fastfetch"
}

feature_fastfetch_2_61_0() {
	FEAT_VERSION="2_61_0"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/fastfetch-cli/fastfetch/releases/download/2.61.0/fastfetch-macos-amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="fastfetch-macos-amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/fastfetch-cli/fastfetch/releases/download/2.61.0/fastfetch-macos-aarch64.zip"
			FEAT_BINARY_URL_FILENAME_x64="fastfetch-macos-aarch64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/fastfetch-cli/fastfetch/releases/download/2.61.0/fastfetch-linux-amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="fastfetch-linux-amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/fastfetch-cli/fastfetch/releases/download/2.61.0/fastfetch-linux-aarch64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="fastfetch-linux-aarch64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/usr/bin/fastfetch"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/usr/bin"
}

feature_fastfetch_2_53_0() {
	FEAT_VERSION="2_53_0"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/fastfetch-cli/fastfetch/releases/download/2.53.0/fastfetch-macos-amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="fastfetch-macos-amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/fastfetch-cli/fastfetch/releases/download/2.53.0/fastfetch-macos-aarch64.zip"
			FEAT_BINARY_URL_FILENAME_x64="fastfetch-macos-aarch64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/fastfetch-cli/fastfetch/releases/download/2.53.0/fastfetch-linux-amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="fastfetch-linux-amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/fastfetch-cli/fastfetch/releases/download/2.53.0/fastfetch-linux-aarch64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="fastfetch-linux-aarch64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/usr/bin/fastfetch"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/usr/bin"
}




feature_fastfetch_2_5_0() {


	FEAT_VERSION="2_5_0"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/fastfetch-cli/fastfetch/releases/download/2.5.0/fastfetch-2.5.0-Darwin.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="fastfetch-2.5.0-Darwin.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		FEAT_BINARY_URL_x86=
		FEAT_BINARY_URL_FILENAME_x86=""
		FEAT_BINARY_URL_PROTOCOL_x86=""
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/fastfetch-cli/fastfetch/releases/download/2.5.0/fastfetch-2.5.0-Linux.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="fastfetch-2.5.0-Linux.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		FEAT_BINARY_URL_x86=
		FEAT_BINARY_URL_FILENAME_x86=
		FEAT_BINARY_URL_PROTOCOL_x86=
	fi



	# List of files to test if feature is installed
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/usr/bin/fastfetch"
	# PATH to add to system PATH
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/usr/bin"
}




feature_fastfetch_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"

	__feature_callback

}










fi
