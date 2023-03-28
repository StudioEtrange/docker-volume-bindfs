if [ ! "$_weboob_INCLUDED_" = "1" ]; then
_weboob_INCLUDED_=1


# https://git.weboob.org/weboob/weboob

# NOTE : for graphic module, you should install QT5:
#					pip install pyqt5

feature_weboob() {
	FEAT_NAME=weboob

	FEAT_LIST_SCHEMA="1_5:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_LINK="https://weboob.org/"
	FEAT_DESC="Weboob is a collection of applications able to interact with websites, without requiring the user to open them in a browser. It also provides well-defined APIs to talk to websites lacking one."

}


feature_weboob_1_5() {
	FEAT_VERSION=1_5


	FEAT_SOURCE_DEPENDENCIES="miniconda3"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://git.weboob.org/weboob/weboob/uploads/007b56516cfeeea4d5c7e97fd3a1ba1f/weboob-1.5.tar.gz"
	FEAT_SOURCE_URL_FILENAME="weboob-1.5.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/scripts/weboob
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/scripts

}

feature_weboob_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$INSTALL_DIR" "DEST_ERASE STRIP"

	pip install -e "$INSTALL_DIR"


	__feature_callback



}


fi
