if [ ! "$_asciinema_INCLUDED_" = "1" ]; then
_asciinema_INCLUDED_=1


feature_asciinema() {
	FEAT_NAME="asciinema"
	FEAT_LIST_SCHEMA="3_2_0@x64:binary 3_0_0@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Terminal session recorder"
	FEAT_LINK="https://asciinema.org"
}


feature_asciinema_3_2_0() {
	FEAT_VERSION="3_2_0"


	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/asciinema/asciinema/releases/download/v3.2.0/asciinema-x86_64-unknown-linux-gnu"
			FEAT_BINARY_URL_FILENAME_x64="asciinema-x86_64-unknown-linux-gnu-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/asciinema/asciinema/releases/download/v3.2.0/asciinema-aarch64-unknown-linux-gnu"
			FEAT_BINARY_URL_FILENAME_x64="asciinema-aarch64-unknown-linux-gnu-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi

	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/asciinema/asciinema/releases/download/v3.2.0/asciinema-x86_64-apple-darwin"
			FEAT_BINARY_URL_FILENAME_x64="asciinema-x86_64-apple-darwin-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/asciinema/asciinema/releases/download/v3.2.0/asciinema-aarch64-apple-darwin"
			FEAT_BINARY_URL_FILENAME_x64="asciinema-aarch64-apple-darwin-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/asciinema"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}

feature_asciinema_3_0_0() {
	FEAT_VERSION="3_0_0"


	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/asciinema/asciinema/releases/download/v3.0.0/asciinema-x86_64-unknown-linux-gnu"
			FEAT_BINARY_URL_FILENAME_x64="asciinema-x86_64-unknown-linux-gnu-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/asciinema/asciinema/releases/download/v3.0.0/asciinema-aarch64-unknown-linux-gnu"
			FEAT_BINARY_URL_FILENAME_x64="asciinema-aarch64-unknown-linux-gnu-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi

	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/asciinema/asciinema/releases/download/v3.0.0/asciinema-x86_64-apple-darwin"
			FEAT_BINARY_URL_FILENAME_x64="asciinema-x86_64-apple-darwin-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/asciinema/asciinema/releases/download/v3.0.0/asciinema-aarch64-apple-darwin"
			FEAT_BINARY_URL_FILENAME_x64="asciinema-aarch64-apple-darwin-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/asciinema"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}



feature_asciinema_install_binary() {

	__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"
		
	if [ -f "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" ]; then
		mv "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" "${FEAT_INSTALL_ROOT}/asciinema"
		chmod +x "${FEAT_INSTALL_ROOT}/asciinema"
	fi


}


fi
