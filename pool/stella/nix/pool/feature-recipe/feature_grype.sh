if [ ! "$_grype_INCLUDED_" = "1" ]; then
_grype_INCLUDED_=1


feature_grype() {
	FEAT_NAME=grype
	FEAT_LIST_SCHEMA="0_74_0@x64:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="A vulnerability scanner for container images and filesystems"
	FEAT_LINK="https://github.com/anchore/grype"
}

feature_grype_stable() {
	FEAT_VERSION="stable"


	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://bin.equinox.io/c/4VmDzA7iaHb/grype-stable-darwin-amd64.zip"
		FEAT_BINARY_URL_FILENAME_x64="grype-stable-darwin-amd64.zip"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://bin.equinox.io/c/4VmDzA7iaHb/grype-stable-linux-amd64.tgz"
		FEAT_BINARY_URL_FILENAME_x64="grype-stable-linux-amd64.tgz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		FEAT_BINARY_URL_x86="https://bin.equinox.io/c/4VmDzA7iaHb/grype-stable-linux-386.tgz"
		FEAT_BINARY_URL_FILENAME_x86="grype-stable-linux-386.tgz"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/grype"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}



feature_grype_0_74_0() {
	FEAT_VERSION="0_74_0"


	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/anchore/grype/releases/download/v0.74.0/grype_0.74.0_darwin_amd64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="grype_0.74.0_darwin_amd64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/anchore/grype/releases/download/v0.74.0/grype_0.74.0_linux_amd64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="grype_0.74.0_linux_amd64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/grype"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}

# -----------------------------------------
feature_grype_install_binary() {
	__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE  FORCE_NAME ${FEAT_BINARY_URL_FILENAME}"


}



fi
