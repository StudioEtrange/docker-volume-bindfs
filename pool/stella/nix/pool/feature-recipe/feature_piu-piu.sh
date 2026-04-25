if [ ! "$_PIU_PIU_SH_INCLUDED_" = "1" ]; then
_PIU_PIU_SH_INCLUDED_=1



feature_piu-piu() {
	FEAT_NAME="piu-piu"
	FEAT_LIST_SCHEMA="1_2:binary"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="This is an Old School horizontal scroller Shoot Them All game in bash. With multiplayer modes team and duel, using netcat"
	FEAT_LINK="https://github.com/vaniacer/piu-piu-SH"
}

feature_piu-piu_1_2() {
	FEAT_VERSION="1_2"

	FEAT_BINARY_URL="https://github.com/vaniacer/piu-piu-SH/archive/refs/tags/v1.2.tar.gz"
	FEAT_BINARY_URL_FILENAME="piu-piu-v1.2.tar.gz"
	FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/piu-piu"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}

feature_piu-piu_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"

	chmod +x "$FEAT_INSTALL_ROOT/piu-piu"
}

fi
