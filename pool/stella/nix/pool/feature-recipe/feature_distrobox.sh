if [ ! "$_distrobox_INCLUDED_" = "1" ]; then
_distrobox_INCLUDED_=1


feature_distrobox() {
	FEAT_NAME="distrobox"
	FEAT_LIST_SCHEMA="1_8_2_4:binary 1_8_1_2:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Use any linux distribution inside your terminal. Enable both backward and forward compatibility with software and freedom to use whatever distribution youre more comfortable with. Runs on podman, docker or lilipod"
	FEAT_LINK="https://github.com/89luca89/distrobox https://gitlab.com/89luca89/distrobox https://distrobox.it/"
}




feature_distrobox_1_8_2_4() {
	FEAT_VERSION="1_8_2_4"

	FEAT_BINARY_URL="https://github.com/89luca89/distrobox/archive/refs/tags/1.8.2.4.tar.gz"
	FEAT_BINARY_URL_FILENAME="distrobox_1.8.2.4.tar.gz"
	FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"


	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/distrobox"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}


feature_distrobox_1_8_1_2() {
	FEAT_VERSION="1_8_1_2"

	FEAT_BINARY_URL="https://github.com/89luca89/distrobox/archive/refs/tags/1.8.1.2.tar.gz"
	FEAT_BINARY_URL_FILENAME="distrobox_1.8.1.2.tar.gz"
	FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"


	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/distrobox"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}


feature_distrobox_install_binary() {

	__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE FORCE_NAME $FEAT_BINARY_URL_FILENAME STRIP"

}


fi
