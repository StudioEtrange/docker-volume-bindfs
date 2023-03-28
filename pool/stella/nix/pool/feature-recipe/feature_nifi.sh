if [ ! "$_nifi_INCLUDED_" = "1" ]; then
_nifi_INCLUDED_=1




feature_nifi() {

	FEAT_NAME=nifi
	FEAT_LIST_SCHEMA="0_3_0:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}

feature_nifi_0_3_0() {
	FEAT_VERSION=0_3_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_CALLBACK=

	FEAT_BINARY_URL="http://www.apache.org/dist/nifi/0.3.0/nifi-0.3.0-bin.tar.gz"
	FEAT_BINARY_URL_FILENAME=nifi-0.3.0-bin.zip
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/nifi.sh
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



# -----------------------------------------
feature_nifi_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP"

}




fi
