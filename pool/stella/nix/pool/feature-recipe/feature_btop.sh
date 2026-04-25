if [ ! "$_btop_INCLUDED_" = "1" ]; then
_btop_INCLUDED_=1

# Binaries for Linux are statically compiled with musl

feature_btop() {
	FEAT_NAME="btop"
	FEAT_LIST_SCHEMA="1_4_5@x64:binary 1_4_5@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="A monitor for resources"
	FEAT_LINK="https://github.com/aristocratos/btop"
}


feature_btop_1_4_5() {
	FEAT_VERSION="1_4_5"


	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/aristocratos/btop/releases/download/v1.4.5/btop-x86_64-linux-musl.tbz"
			FEAT_BINARY_URL_FILENAME_x64="btop-x86_64-linux-musl.tbz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
			FEAT_BINARY_URL_x86="https://github.com/aristocratos/btop/releases/download/v1.4.5/btop-i686-linux-musl.tbz"
			FEAT_BINARY_URL_FILENAME_x86="btop-i686-linux-musl.tbz"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/aristocratos/btop/releases/download/v1.4.5/btop-aarch64-linux-musl.tbz"
			FEAT_BINARY_URL_FILENAME_x64="btop-aarch64-linux-musl.tbz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi


	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/btop/bin/btop"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/btop/bin"
}



feature_btop_install_binary() {

	__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE STRIP"


}


fi
