if [ ! "$_oc_INCLUDED_" = "1" ]; then
_oc_INCLUDED_=1


feature_oc() {
	FEAT_NAME="oc"
	FEAT_LIST_SCHEMA="latest@x64:binary 4_14_7@x64:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="openshift client"
	FEAT_LINK="https://github.com/wagoodman/oc"
}



feature_oc_latest() {
	FEAT_VERSION="latest"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="openshift-client-linux.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-mac.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="openshift-client-mac.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	FEAT_BINARY_CALLBACK="feature_oc_remove_cache"
	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/oc"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}


feature_oc_4_14_7() {
	FEAT_VERSION="4_14_7"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.14.7/openshift-client-linux-4.14.7.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="openshift-client-linux-4.14.7.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.14.7/openshift-client-mac-4.14.7.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="openshift-client-mac-4.14.7.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	FEAT_BINARY_CALLBACK=""
	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/oc"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}

# remote previously downloaded file from internal cache
feature_oc_remove_cache() {
	rm -Rf "$STELLA_APP_CACHE_DIR/$FEAT_BINARY_URL_FILENAME"
}

feature_oc_install_binary() {

	__feature_callback
	__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE FORCE_NAME $FEAT_BINARY_URL_FILENAME"

}


fi
