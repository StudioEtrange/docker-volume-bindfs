if [ ! "$_k0s_INCLUDED_" = "1" ]; then
_k0s_INCLUDED_=1

# the version number is the same than the upstream kubernetes source code
# with the exception of the right part (k0s_0) which is a fix version made by k0s itself 
feature_k0s() {
	FEAT_NAME="k0s"
	FEAT_LIST_SCHEMA="1_28_4_k0s_0@x64:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="k0s is an all-inclusive Kubernetes distribution, which is configured with all of the features needed to build a Kubernetes cluster and packaged as a single binary for ease of use."
	FEAT_LINK="https://github.com/k0sproject/k0s https://docs.k0sproject.io/"
}


feature_k0s_1_28_4_k0s_0() {
	FEAT_VERSION="1_28_4_k0s_0"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/k0sproject/k0s/releases/download/v1.28.4%2Bk0s.0/k0s-v1.28.4+k0s.0-amd64"
		FEAT_BINARY_URL_FILENAME_x64="k0s-v1.28.4+k0s.0-amd64"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi
	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/k0s"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}


feature_k0s_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE FORCE_NAME $FEAT_BINARY_URL_FILENAME"
	mv -f "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME" "$FEAT_INSTALL_ROOT/k0s"
	chmod +x "$FEAT_INSTALL_ROOT/k0s"

}


fi
