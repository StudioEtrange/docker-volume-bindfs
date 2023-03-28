if [ ! "$_yarn_INCLUDED_" = "1" ]; then
_yarn_INCLUDED_=1


feature_yarn() {
	FEAT_NAME=yarn
	FEAT_LIST_SCHEMA="1_16_0:binary 1_22_10:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Fast, reliable, and secure dependency management."
	FEAT_LINK="https://yarnpkg.com"
}

feature_yarn_1_22_10() {

	FEAT_VERSION=1_22_10


	FEAT_BINARY_URL="https://github.com/yarnpkg/yarn/releases/download/v1.22.10/yarn-v1.22.10.tar.gz"
	FEAT_BINARY_URL_FILENAME="yarn-v1.22.10.tar.gz"
	FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"

	FEAT_INSTALL_TEST=$FEAT_INSTALL_ROOT/bin/yarn
	FEAT_SEARCH_PATH=$FEAT_INSTALL_ROOT/bin

}


feature_yarn_1_16_0() {

	FEAT_VERSION=1_16_0


	FEAT_BINARY_URL="https://github.com/yarnpkg/yarn/releases/download/v1.16.0/yarn-v1.16.0.tar.gz"
	FEAT_BINARY_URL_FILENAME="yarn-v1.16.0.tar.gz"
	FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"

	FEAT_INSTALL_TEST=$FEAT_INSTALL_ROOT/bin/yarn
	FEAT_SEARCH_PATH=$FEAT_INSTALL_ROOT/bin

}



feature_yarn_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"


}


fi
