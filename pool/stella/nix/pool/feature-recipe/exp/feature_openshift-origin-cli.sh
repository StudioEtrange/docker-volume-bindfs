# https://github.com/openshift/origin/releases
if [ ! "$_openshiftorigincli_INCLUDED_" = "1" ]; then
_openshiftorigincli_INCLUDED_=1

feature_openshift-origin-cli() {
	FEAT_NAME=openshift-origin-cli
	FEAT_LIST_SCHEMA="1_3_1:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}

# with openshift origin 1.3.1
feature_openshift-origin-cli_1_3_1() {
	FEAT_VERSION=1_3_1
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://github.com/openshift/origin/releases/download/v1.3.1/openshift-origin-client-tools-v1.3.1-dad658de7465ba8a234a4fb40b5b446a45a4cee1-linux-64bit.tar.gz
		FEAT_BINARY_URL_FILENAME=openshift-origin-client-tools-v1.3.1-dad658de7465ba8a234a4fb40b5b446a45a4cee1-linux-64bit.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://github.com/openshift/origin/releases/download/v1.3.1/openshift-origin-client-tools-v1.3.1-dad658de7465ba8a234a4fb40b5b446a45a4cee1-mac.zip
		FEAT_BINARY_URL_FILENAME=openshift-origin-client-tools-v1.3.1-dad658de7465ba8a234a4fb40b5b446a45a4cee1-mac.zip
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/oc
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}



feature_openshift-origin-cli_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT"

}


fi
