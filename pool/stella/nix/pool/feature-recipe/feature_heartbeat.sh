if [ ! "$_heartbeat_INCLUDED_" = "1" ]; then
_heartbeat_INCLUDED_=1



feature_heartbeat() {
	FEAT_NAME=heartbeat
	FEAT_LIST_SCHEMA="5_6_4:binary 5_6_0:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}



feature_heartbeat_5_6_4() {
	FEAT_VERSION=5_6_4

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-5.6.4-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=heartbeat-5.6.4-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-5.6.4-linux-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=heartbeat-5.6.4-linux-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/heartbeat
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}



feature_heartbeat_5_6_0() {
	FEAT_VERSION=5_6_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-5.6.0-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=heartbeat-5.6.0-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-5.6.0-linux-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=heartbeat-5.6.0-linux-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/heartbeat
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_heartbeat_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"
}


fi
