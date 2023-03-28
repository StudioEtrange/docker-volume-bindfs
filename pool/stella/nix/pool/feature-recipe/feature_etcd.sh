if [ ! "$_etcd_INCLUDED_" = "1" ]; then
_etcd_INCLUDED_=1



feature_etcd() {
	FEAT_NAME=etcd
	FEAT_LIST_SCHEMA="3_3_10@x64:binary 2_3_7@x64:binary"
	FEAT_DEFAULT_ARCH=x64
	FEAT_DEFAULT_FLAVOUR="binary"
}


feature_etcd_3_3_10() {
	FEAT_VERSION=3_3_10


	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64=https://github.com/etcd-io/etcd/releases/download/v3.3.10/etcd-v3.3.10-linux-arm64.tar.gz
		FEAT_BINARY_URL_FILENAME_x64=etcd-v3.3.10-linux-arm64.tar.gz
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64=https://github.com/etcd-io/etcd/releases/download/v3.3.10/etcd-v3.3.10-darwin-amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=etcd-v2.3.7-darwin-amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/etcd
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_etcd_2_3_7() {
	FEAT_VERSION=2_3_7
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86=
		FEAT_BINARY_URL_FILENAME_x86=
		FEAT_BINARY_URL_PROTOCOL_x86=
		FEAT_BINARY_URL_x64=https://github.com/etcd-io/etcd/releases/download/v2.3.7/etcd-v2.3.7-linux-amd64.tar.gz
		FEAT_BINARY_URL_FILENAME_x64=etcd-v2.3.7-linux-amd64.tar.gz
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=
		FEAT_BINARY_URL_FILENAME_x86=
		FEAT_BINARY_URL_PROTOCOL_x86=
		FEAT_BINARY_URL_x64=https://github.com/etcd-io/etcd/releases/download/v2.3.7/etcd-v2.3.7-darwin-amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=etcd-v2.3.7-darwin-amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/etcd
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}



feature_etcd_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP"

}


fi
