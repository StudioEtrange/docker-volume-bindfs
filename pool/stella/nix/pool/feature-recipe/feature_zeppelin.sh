if [ ! "$_zeppelin_INCLUDED_" = "1" ]; then
_zeppelin_INCLUDED_=1


feature_zeppelin() {
	FEAT_NAME=zeppelin
	FEAT_LIST_SCHEMA="0_6_1:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}




feature_zeppelin_0_6_1() {
	FEAT_VERSION=0_6_1
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	FEAT_BINARY_URL=https://archive.apache.org/dist/zeppelin/zeppelin-0.6.1/zeppelin-0.6.1-bin-all.tgz
	FEAT_BINARY_URL_FILENAME=zeppelin-0.6.1-bin-all.tgz
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/zeppelin.sh
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_zeppelin_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP"

}


fi
