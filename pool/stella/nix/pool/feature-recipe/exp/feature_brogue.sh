if [ ! "$_BROGUE_INCLUDED_" = "1" ]; then
_BROGUE_INCLUDED_=1

# TODO needs SDL2

feature_brogue() {
	FEAT_NAME="brogue"
	FEAT_LIST_SCHEMA="1_14_1@x64:binary"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Brogue is a direct descendant of Rogue, a dungeon crawling video game. Brogue: Community Edition - a community-lead fork of the much-loved minimalist roguelike game"
	FEAT_LINK="https://github.com/tmewett/BrogueCE https://sites.google.com/site/broguegame/"
}

feature_brogue_1_14_1() {
	FEAT_VERSION="1_14_1"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/tmewett/BrogueCE/releases/download/v1.14.1/BrogueCE-1.14.1-macos-x86_64.zip"
		FEAT_BINARY_URL_FILENAME_x64="BrogueCE-1.14.1-macos-x86_64.zip"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/tmewett/BrogueCE/releases/download/v1.14.1/BrogueCE-1.14.1-linux-x86_64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="BrogueCE-1.14.1-linux-x86_64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/brogue"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"
}

feature_brogue_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		mkdir -p "$FEAT_INSTALL_ROOT/bin"
		ln -s "$FEAT_INSTALL_ROOT/Brogue CE.app/Contents/MacOS/brogue" "$FEAT_INSTALL_ROOT/bin/brogue"
	fi
}

fi
