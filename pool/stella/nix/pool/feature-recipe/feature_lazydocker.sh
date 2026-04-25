if [ ! "$_LAZYDOCKER_INCLUDED_" = "1" ]; then
_LAZYDOCKER_INCLUDED_=1


feature_lazydocker() {
	FEAT_NAME="lazydocker"
	FEAT_LIST_SCHEMA="0_25_0@x64:binary 0_24_1@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="A simple terminal UI for both docker and docker-compose, written in Go with the gocui library."
	FEAT_LINK="https://github.com/jesseduffield/lazydocker"
}




feature_lazydocker_0_25_0() {


	FEAT_VERSION="0_25_0"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jesseduffield/lazydocker/releases/download/v0.25.0/lazydocker_0.25.0_Darwin_x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="docker_0.25.0_Darwin_x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jesseduffield/lazydocker/releases/download/v0.25.0/lazydocker_0.25.0_Darwin_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="lazydocker_0.25.0_Darwin_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jesseduffield/lazydocker/releases/download/v0.25.0/lazydocker_0.25.0_Linux_x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="lazydocker_0.25.0_Linux_x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jesseduffield/lazydocker/releases/download/v0.25.0/lazydocker_0.25.0_Linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="lazydocker_0.25.0_Linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	# List of files to test if feature is installed
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/lazydocker"
	# PATH to add to system PATH
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}

feature_lazydocker_0_24_1() {


	FEAT_VERSION="0_24_1"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jesseduffield/lazydocker/releases/download/v0.24.1/lazydocker_0.24.1_Darwin_x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="docker_0.24.1_Darwin_x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jesseduffield/lazydocker/releases/download/v0.24.1/lazydocker_0.24.1_Darwin_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="lazydocker_0.24.1_Darwin_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jesseduffield/lazydocker/releases/download/v0.24.1/lazydocker_0.24.1_Linux_x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="lazydocker_0.24.1_Linux_x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jesseduffield/lazydocker/releases/download/v0.24.1/lazydocker_0.24.1_Linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="lazydocker_0.24.1_Linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
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
