
if [ ! "$_CHISEL_INCLUDED_" = "1" ]; then
_CHISEL_INCLUDED_=1


feature_chisel() {
	FEAT_NAME="chisel"
	FEAT_LIST_SCHEMA="1_11_5@x64:binary 1_11_3@x64:binary 1_11_5@86:binary 1_11_3@86:binary"

	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="A fast TCP/UDP tunnel over HTTP"
	FEAT_LINK="https://github.com/jpillora/chisel"
}

feature_chisel_1_11_5() {
	FEAT_VERSION="1_11_5"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/chisel/releases/download/v1.11.5/chisel_1.11.5_darwin_amd64.gz"
			FEAT_BINARY_URL_FILENAME_x64="chisel_1.11.5_darwin_amd64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/chisel/releases/download/v1.11.5/chisel_1.11.5_darwin_arm64.gz"
			FEAT_BINARY_URL_FILENAME_x64="chisel_1.11.5_darwin_arm64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/chisel/releases/download/v1.11.5/chisel_1.11.5_linux_amd64.gz"
			FEAT_BINARY_URL_FILENAME_x64="chisel_1.11.5_linux_amd64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86="https://github.com/jpillora/chisel/releases/download/v1.11.5/chisel_1.11.5_linux_386.gz"
			FEAT_BINARY_URL_FILENAME_x86="chisel_1.11.5_linux_386.gz"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/chisel/releases/download/v1.11.5/chisel_1.11.5_linux_arm64.gz"
			FEAT_BINARY_URL_FILENAME_x64="chisel_1.11.5_linux_arm64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86="https://github.com/jpillora/chisel/releases/download/v1.11.5/chisel_1.11.5_linux_armv7.gz"
			FEAT_BINARY_URL_FILENAME_x86="chisel_1.11.5_linux_armv7.gz"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/chisel"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_chisel_1_11_3() {
	FEAT_VERSION="1_11_3"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/chisel/releases/download/v1.11.3/chisel_1.11.3_darwin_amd64.gz"
			FEAT_BINARY_URL_FILENAME_x64="chisel_1.11.3_darwin_amd64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/chisel/releases/download/v1.11.3/chisel_1.11.3_darwin_arm64.gz"
			FEAT_BINARY_URL_FILENAME_x64="chisel_1.11.3_darwin_arm64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/chisel/releases/download/v1.11.3/chisel_1.11.3_linux_amd64.gz"
			FEAT_BINARY_URL_FILENAME_x64="chisel_1.11.3_linux_amd64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86="https://github.com/jpillora/chisel/releases/download/v1.11.3/chisel_1.11.3_linux_386.gz"
			FEAT_BINARY_URL_FILENAME_x86="chisel_1.11.3_linux_386.gz"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jpillora/chisel/releases/download/v1.11.3/chisel_1.11.3_linux_arm64.gz"
			FEAT_BINARY_URL_FILENAME_x64="chisel_1.11.3_linux_arm64.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86="https://github.com/jpillora/chisel/releases/download/v1.11.3/chisel_1.11.3_linux_armv7.gz"
			FEAT_BINARY_URL_FILENAME_x86="chisel_1.11.3_linux_armv7.gz"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/chisel"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_chisel_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE"

	if [ -f "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME%.*}" ]; then
		mv "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME%.*}" "${FEAT_INSTALL_ROOT}/chisel"
		chmod +x "${FEAT_INSTALL_ROOT}/chisel"
	fi

}




fi