if [ ! "$_VIDDY_INCLUDED_" = "1" ]; then
_VIDDY_INCLUDED_=1


feature_viddy() {
	FEAT_NAME="viddy"
	FEAT_LIST_SCHEMA="1_3_0@x64:binary"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Modern watch command. Time machine and pager etc."
	FEAT_LINK="https://github.com/sachaos/viddy"
}


feature_viddy_1_3_0() {
	FEAT_VERSION="1_3_0"

	# Darwin
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/sachaos/viddy/releases/download/v1.3.0/viddy-v1.3.0-macos-x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="viddy-v1.3.0-macos-x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/sachaos/viddy/releases/download/v1.3.0/viddy-v1.3.0-macos-arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="viddy-v1.3.0-macos-arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	# Linux
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/sachaos/viddy/releases/download/v1.3.0/viddy-v1.3.0-linux-x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="viddy-v1.3.0-linux-x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86="https://github.com/sachaos/viddy/releases/download/v1.3.0/viddy-v1.3.0-linux-i386.tar.gz"
			FEAT_BINARY_URL_FILENAME_x86="viddy-v1.3.0-linux-i386.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/sachaos/viddy/releases/download/v1.3.0/viddy-v1.3.0-linux-arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="viddy-v1.3.0-linux-arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/viddy"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}


feature_viddy_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT"
}

fi
