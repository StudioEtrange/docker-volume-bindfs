if [ ! "$_pycharm_INCLUDED_" = "1" ]; then
_pycharm_INCLUDED_=1


# TODO : for darwin

feature_pycharm() {

	FEAT_NAME=pycharm
	[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && FEAT_LIST_SCHEMA="2018_1_0_community:binary 2017_2_3_community:binary"
	[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && FEAT_LIST_SCHEMA=
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}




feature_pycharm_2018_1_0_community() {
	FEAT_VERSION=2018_1_0_community

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_CALLBACK=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL="https://download.jetbrains.com/python/pycharm-community-2018.1.tar.gz"
		FEAT_BINARY_URL_FILENAME=pycharm-community-2018.1.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/pycharm.sh
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_pycharm_2017_2_3_community() {
	FEAT_VERSION=2017_2_3_community

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_CALLBACK=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL="https://download.jetbrains.com/python/pycharm-community-2017.2.3.tar.gz"
		FEAT_BINARY_URL_FILENAME=pycharm-community-2017.2.3.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/pycharm.sh
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



# -----------------------------------------
feature_pycharm_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP"

}




fi
