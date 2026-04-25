if [ ! "$_IPSW_DAEMON_INCLUDED_" = "1" ]; then
_IPSW_DAEMON_INCLUDED_=1


feature_ipsw-daemon() {
	FEAT_NAME="ipsw-daemon"
	FEAT_LIST_SCHEMA="3_1_671@x64:binary 3_1_632@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="iOS/macOS Research Swiss Army Knife - DAEMON PART"
	FEAT_LINK="https://github.com/blacktop/ipsw https://blacktop.github.io/ipsw"
}

feature_ipsw-daemon_3_1_671() {
	FEAT_VERSION="3_1_671"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/blacktop/ipsw/releases/download/v3.1.671/ipswd_3.1.671_macOS_x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="ipswd_3.1.671_macOS_x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="hhttps://github.com/blacktop/ipsw/releases/download/v3.1.671/ipswd_3.1.671_macOS_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="ipswd_3.1.671_macOS_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/blacktop/ipsw/releases/download/v3.1.671/ipswd_3.1.671_linux_x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="ipswd_3.1.671_linux_x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/blacktop/ipsw/releases/download/v3.1.671/ipswd_3.1.671_linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="ipswd_3.1.671_linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/ipswd"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}

feature_ipsw-daemon_3_1_632() {
	FEAT_VERSION="3_1_632"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/blacktop/ipsw/releases/download/v3.1.632/ipswd_3.1.632_macOS_x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="ipswd_3.1.632_macOS_x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="hhttps://github.com/blacktop/ipsw/releases/download/v3.1.632/ipswd_3.1.632_macOS_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="ipswd_3.1.632_macOS_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/blacktop/ipsw/releases/download/v3.1.632/ipswd_3.1.632_linux_x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="ipswd_3.1.632_linux_x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/blacktop/ipsw/releases/download/v3.1.632/ipswd_3.1.632_linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="ipswd_3.1.632_linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/ipswd"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}



feature_ipsw-daemon_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE"
	

}








fi
