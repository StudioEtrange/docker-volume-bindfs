if [ ! "$_ccda_INCLUDED_" = "1" ]; then
_ccda_INCLUDED_=1


feature_ccda() {
	FEAT_NAME="ccda"
	FEAT_LIST_SCHEMA='2025_10_10_0307@x64:binary'
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Cataclysm: Dark Days Ahead is a turn-based survival game set in a post-apocalyptic world."
	FEAT_LINK="https://cataclysm-dda.org/ https://github.com/CleverRaven/Cataclysm-DDA"
}


feature_ccda_2025_10_10_0307() {
	FEAT_VERSION="2025_10_10_0307"


	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/CleverRaven/Cataclysm-DDA/releases/download/cdda-0.I-2025-10-10-0307/cdda-linux-terminal-only-x64-2025-10-10-0307.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="cdda-linux-terminal-only-x64-2025-10-10-0307.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/cataclysm-launcher"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}



feature_ccda_install_binary() {

	__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE STRIP"

}


fi
