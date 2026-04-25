if [ ! "$_SHFMT_INCLUDED_" = "1" ]; then
_SHFMT_INCLUDED_=1


feature_shfmt() {
	FEAT_NAME="shfmt"
	[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && FEAT_LIST_SCHEMA="3_12_0@x64:binary 3_12_0@x86:binary"
	[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && FEAT_LIST_SCHEMA="3_12_0@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="A shell parser, formatter, and interpreter with bash support"
	FEAT_LINK="https://github.com/mvdan/sh https://pkg.go.dev/mvdan.cc/sh/v3"
}

feature_shfmt_3_12_0() {

	FEAT_VERSION="3_12_0"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mvdan/sh/releases/download/v3.12.0/shfmt_v3.12.0_darwin_amd64"
			FEAT_BINARY_URL_FILENAME_x64="shfmt_v3.12.0_darwin_amd64"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mvdan/sh/releases/download/v3.12.0/shfmt_v3.12.0_darwin_arm64"
			FEAT_BINARY_URL_FILENAME_x64="shfmt_v3.12.0_darwin_arm64"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mvdan/sh/releases/download/v3.12.0/shfmt_v3.12.0_linux_amd64"
			FEAT_BINARY_URL_FILENAME_x64="shfmt_v3.12.0_linux_amd64"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
			FEAT_BINARY_URL_x86="https://github.com/mvdan/sh/releases/download/v3.12.0/shfmt_v3.12.0_linux_386"
			FEAT_BINARY_URL_FILENAME_x86="shfmt_v3.12.0_linux_386"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mvdan/sh/releases/download/v3.12.0/shfmt_v3.12.0_linux_arm64"
			FEAT_BINARY_URL_FILENAME_x64="shfmt_v3.12.0_linux_arm64"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
			FEAT_BINARY_URL_x86="https://github.com/mvdan/sh/releases/download/v3.12.0/shfmt_v3.12.0_linux_arm"
			FEAT_BINARY_URL_FILENAME_x86="shfmt_v3.12.0_linux_arm"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		fi
	fi

	FEAT_ENV_CALLBACK=""

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/shfmt"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}


feature_shfmt_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"
	
	if [ -f "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" ]; then
		mv "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" "${FEAT_INSTALL_ROOT}/shfmt"
		chmod +x "${FEAT_INSTALL_ROOT}/shfmt"
	fi

}








fi
