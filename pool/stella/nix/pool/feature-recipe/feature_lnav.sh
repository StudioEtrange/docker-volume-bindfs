if [ ! "$_lnav_INCLUDED_" = "1" ]; then
_lnav_INCLUDED_=1



feature_lnav() {

	FEAT_NAME=lnav
	FEAT_LIST_SCHEMA="0_8_5:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="An advanced log file viewer for the small-scale"
	FEAT_LINK="http://lnav.org/"
}

feature_lnav_0_8_5() {
	FEAT_VERSION=0_8_5

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_BINARY_URL="https://github.com/tstack/lnav/releases/download/v0.8.5/lnav-0.8.5-linux-64bit.zip"
	FEAT_BINARY_URL_FILENAME="lnav-0.8.5-linux-64bit.zip"
	FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lnav
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_lnav_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP"
	

	
}




fi
