if [ ! "$_goreman_INCLUDED_" = "1" ]; then
_goreman_INCLUDED_=1


feature_goreman() {
	FEAT_NAME="goreman"
	FEAT_LIST_SCHEMA="0_3_17@x64:binary 0_3_16@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="a process manager like foreman written in go language"
	FEAT_LINK="https://github.com/mattn/goreman"
}


feature_goreman_0_3_17() {
	FEAT_VERSION="0_3_17"


	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mattn/goreman/releases/download/v0.3.17/goreman_v0.3.17_linux_amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="goreman_v0.3.17_linux_amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mattn/goreman/releases/download/v0.3.17/goreman_v0.3.17_linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="goreman_v0.3.17_linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mattn/goreman/releases/download/v0.3.17/goreman_v0.3.17_darwin_amd64.zip"
			FEAT_BINARY_URL_FILENAME_x64="goreman_v0.3.17_darwin_amd64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mattn/goreman/releases/download/v0.3.17/goreman_v0.3.17_darwin_arm64.zip"
			FEAT_BINARY_URL_FILENAME_x64="goreman_v0.3.17_darwin_arm64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/goreman"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}

feature_goreman_0_3_16() {
	FEAT_VERSION="0_3_16"


	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mattn/goreman/releases/download/v0.3.16/goreman_v0.3.16_linux_amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="goreman_v0.3.16_linux_amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mattn/goreman/releases/download/v0.3.16/goreman_v0.3.16_linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="goreman_v0.3.16_linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mattn/goreman/releases/download/v0.3.16/goreman_v0.3.16_darwin_amd64.zip"
			FEAT_BINARY_URL_FILENAME_x64="goreman_v0.3.16_darwin_amd64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mattn/goreman/releases/download/v0.3.16/goreman_v0.3.16_darwin_arm64.zip"
			FEAT_BINARY_URL_FILENAME_x64="goreman_v0.3.16_darwin_arm64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/goreman"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}



feature_goreman_install_binary() {

	__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"

}


fi
