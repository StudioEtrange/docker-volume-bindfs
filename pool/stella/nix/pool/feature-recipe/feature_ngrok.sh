if [ ! "$_NGROK_INCLUDED_" = "1" ]; then
_NGROK_INCLUDED_=1


feature_ngrok() {
	FEAT_NAME=ngrok
	# version stable is considered in order the one to choose by default
	FEAT_LIST_SCHEMA="stable@x86:binary\macos stable@x64:binary 2_3_40@x86:binary\macos 2_3_40@x64:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="ngrok is the programmable network edge that adds connectivity, security, and observability to your apps with no code changes"
	FEAT_LINK="https://ngrok.com/ https://dl.equinox.io/ngrok/ngrok/stable"
}

feature_ngrok_stable() {
	FEAT_VERSION="stable"


	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-darwin-amd64.zip"
		FEAT_BINARY_URL_FILENAME_x64="ngrok-stable-darwin-amd64.zip"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.tgz"
		FEAT_BINARY_URL_FILENAME_x64="ngrok-stable-linux-amd64.tgz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		FEAT_BINARY_URL_x86="https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.tgz"
		FEAT_BINARY_URL_FILENAME_x86="ngrok-stable-linux-386.tgz"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/ngrok"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}



feature_ngrok_2_3_40() {
	FEAT_VERSION="2_3_40"


	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://bin.equinox.io/a/mL7fbqPrAXM/ngrok-2.3.40-darwin-amd64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="ngrok-2.3.40-darwin-amd64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://bin.equinox.io/a/6sdfF9NmmRW/ngrok-2.3.40-linux-amd64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="ngrok-2.3.40-linux-amd64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		FEAT_BINARY_URL_x86="https://bin.equinox.io/a/gsR7QMLiGHR/ngrok-2.3.40-linux-386.tar.gz"
		FEAT_BINARY_URL_FILENAME_x86="ngrok-2.3.40-linux-386.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/ngrok"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}

# -----------------------------------------
feature_ngrok_install_binary() {
	__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE  FORCE_NAME ${FEAT_BINARY_URL_FILENAME}"


}



fi
