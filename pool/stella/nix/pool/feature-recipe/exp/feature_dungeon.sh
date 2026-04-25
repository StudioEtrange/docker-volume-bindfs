if [ ! "$_dungeon_INCLUDED_" = "1" ]; then
_dungeon_INCLUDED_=1

# TODO
# for latest_homebrew
#		linuw missing dependencies : gfortran

feature_dungeon() {
	FEAT_NAME="dungeon"
	FEAT_LIST_SCHEMA="latest_homebrew:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="The classic text adventure updated to compile using gfortran"
	FEAT_LINK="https://github.com/GOFAI/dungeon https://formulae.brew.sh/formula/dungeon"
}


feature_dungeon_latest_homebrew() {
	FEAT_VERSION="latest_homebrew"

	FEAT_BINARY_URL="dungeon"
	FEAT_BINARY_URL_PROTOCOL="HOMEBREW_BOTTLE"

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/bin/dungeon"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/bin"
}



feature_dungeon_install_binary() {

	case $FEAT_BINARY_URL_PROTOCOL in
		HOMEBREW_BOTTLE)
			__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE"
			;;
	esac
	
	

}


fi
