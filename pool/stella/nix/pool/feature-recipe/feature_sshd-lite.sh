if [ ! "$_SSHD_LITE_INCLUDED_" = "1" ]; then
_SSHD_LITE_INCLUDED_=1

# NOTE ALTERNATIVE : ssh go framework https://github.com/gliderlabs/ssh

feature_sshd-lite() {
	FEAT_NAME="sshd-lite"
	FEAT_LIST_SCHEMA="1_38_0@x64:binary 1_20_0@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="A feature-light sshd(8) for Windows, Mac, and Linux written in Go. Experimental."
	FEAT_LINK="https://github.com/jpillora/sshd-lite"
}

feature_sshd-lite_1_38_0() {

	FEAT_VERSION="1_38_0"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/sshd-lite/releases/download/v1.38.0/sshd-lite_1.38.0_darwin_amd64.gz"
			FEAT_BINARY_URL_FILENAME_x64="sshd-lite_1.38.0_darwin_amd64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/sshd-lite/releases/download/v1.38.0/sshd-lite_1.38.0_darwin_arm64.gz"
			FEAT_BINARY_URL_FILENAME_x64="sshd-lite_1.38.0_darwin_arm64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/sshd-lite/releases/download/v1.38.0/sshd-lite_1.38.0_linux_amd64.gz"
			FEAT_BINARY_URL_FILENAME_x64="sshd-lite_1.38.0_linux_amd64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/sshd-lite/releases/download/v1.38.0/sshd-lite_1.38.0_linux_arm64.gz"
			FEAT_BINARY_URL_FILENAME_x64="sshd-lite_1.38.0_linux_arm64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/sshd-lite"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}

feature_sshd-lite_1_20_0() {

	FEAT_VERSION="1_20_0"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/sshd-lite/releases/download/v1.20.0/sshd-lite_1.20.0_darwin_amd64.gz"
			FEAT_BINARY_URL_FILENAME_x64="sshd-lite_1.20.0_darwin_amd64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/sshd-lite/releases/download/v1.20.0/sshd-lite_1.20.0_darwin_arm64.gz"
			FEAT_BINARY_URL_FILENAME_x64="sshd-lite_1.20.0_darwin_arm64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/sshd-lite/releases/download/v1.20.0/sshd-lite_1.20.0_linux_amd64.gz"
			FEAT_BINARY_URL_FILENAME_x64="sshd-lite_1.20.0_linux_amd64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/sshd-lite/releases/download/v1.20.0/sshd-lite_1.20.0_linux_arm64.gz"
			FEAT_BINARY_URL_FILENAME_x64="sshd-lite_1.20.0_linux_arm64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/sshd-lite"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}

feature_sshd-lite_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE"
		
	for f in ${FEAT_INSTALL_ROOT}/sshd-lite*; do
		if [ -f "$f" ]; then
			mv "$f" "${FEAT_INSTALL_ROOT}/sshd-lite"
			chmod +x "${FEAT_INSTALL_ROOT}/sshd-lite"
		fi
	done

}








fi
