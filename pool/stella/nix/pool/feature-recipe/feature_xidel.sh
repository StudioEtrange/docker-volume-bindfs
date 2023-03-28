if [ ! "$_xidel_INCLUDED_" = "1" ]; then
_xidel_INCLUDED_=1

feature_xidel() {
	FEAT_NAME="xidel"
	[ "${STELLA_CURRENT_PLATFORM}" = "linux" ] && FEAT_LIST_SCHEMA="0_9_8@x64:binary 0_9_8@x86:binary"
	[ "${STELLA_CURRENT_PLATFORM}" = "darwin" ] && FEAT_LIST_SCHEMA=""
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="A command line tool to download and extract data from HTML/XML pages or JSON-APIs, using CSS, XPath 3.0, XQuery 3.0, JSONiq or pattern templates. It can also create new or transformed XML/HTML/JSON documents."
	FEAT_LINK="http://www.videlibri.de/xidel.html https://github.com/benibela/xidel"
}


feature_xidel_0_9_8() {
	FEAT_VERSION="0_9_8"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x86="https://github.com/benibela/xidel/releases/download/Xidel_0.9.8/xidel-0.9.8.linux32.tar.gz"
		FEAT_BINARY_URL_FILENAME_x86="xidel-0.9.8.linux32.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		FEAT_BINARY_URL_x64="https://github.com/benibela/xidel/releases/download/Xidel_0.9.8/xidel-0.9.8.linux64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="xidel-0.9.8.linux64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

	fi
	

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}"/xidel
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}


feature_xidel_install_binary() {

	__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE FORCE_NAME $FEAT_BINARY_URL_FILENAME"

	#mv "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" "${FEAT_INSTALL_ROOT}/xidel"
	#chmod +x "${FEAT_INSTALL_ROOT}/xidel"

}


fi
