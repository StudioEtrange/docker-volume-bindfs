if [ ! "$_superfile_INCLUDED_" = "1" ]; then
_superfile_INCLUDED_=1


feature_superfile() {
	FEAT_NAME="superfile"
	FEAT_LIST_SCHEMA="1_5_0@x64:binary 1_4_0@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Modern terminal file manager"
	FEAT_LINK="https://github.com/yorukot/superfile https://superfile.dev"
}


feature_superfile_1_5_0() {
	FEAT_VERSION="1_5_0"


	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/yorukot/superfile/releases/download/v1.5.0/superfile-linux-v1.5.0-amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="superfile-linux-v1.5.0-amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/yorukot/superfile/releases/download/v1.5.0/superfile-linux-v1.5.0-arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="superfile-linux-v1.5.0-arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/yorukot/superfile/releases/download/v1.5.0/superfile-darwin-v1.5.0-amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="superfile-darwin-v1.5.0-amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/yorukot/superfile/releases/download/v1.5.0/superfile-darwin-v1.5.0-arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="superfile-darwin-v1.5.0-arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/spf"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}

feature_superfile_1_4_0() {
	FEAT_VERSION="1_4_0"


	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/yorukot/superfile/releases/download/v1.4.0/superfile-linux-v1.4.0-amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="superfile-linux-v1.4.0-amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/yorukot/superfile/releases/download/v1.4.0/superfile-linux-v1.4.0-arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="superfile-linux-v1.4.0-arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/yorukot/superfile/releases/download/v1.4.0/superfile-darwin-v1.4.0-amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="superfile-darwin-v1.4.0-amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/yorukot/superfile/releases/download/v1.4.0/superfile-darwin-v1.4.0-arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="superfile-darwin-v1.4.0-arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/spf"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}



feature_superfile_install_binary() {

	__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE STRIP"
	if [ -f "${FEAT_INSTALL_ROOT}"/*/*/"spf" ]; then
		mv "${FEAT_INSTALL_ROOT}"/*/*/"spf" "${FEAT_INSTALL_ROOT}/spf"
		chmod +x "${FEAT_INSTALL_ROOT}/spf"
	fi
}


fi
