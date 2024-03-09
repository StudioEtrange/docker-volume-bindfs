if [ ! "$_miniforge3_INCLUDED_" = "1" ]; then
_miniforge3_INCLUDED_=1

# miniforge3 releases from https://github.com/conda-forge/miniforge can install different python env management tools
#		Miniforge3 and Mambaforge are identical "That said, if you had to start using one today, we recommend to stick to Miniforge."
# all connected to conda-forge package repository

# list of versions : https://github.com/conda-forge/miniforge/releases

feature_miniforge3() {
	FEAT_NAME="miniforge3"
	FEAT_LIST_SCHEMA="23_3_1_1@x64:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Minimal env and package python manager with conda as environment management tool and connected to conda-forge."
	FEAT_LINK="https://github.com/conda-forge/miniforge"
}


feature_miniforge3_23_3_1_1() {
	FEAT_VERSION="23_3_1_1"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/23.3.1-1/Miniforge3-23.3.1-1-MacOSX-x86_64.sh"
		FEAT_BINARY_URL_FILENAME_x64="Miniforge3-23.3.1-1-MacOSX-x86_64.sh"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/23.3.1-1/Miniforge3-23.3.1-1-Linux-x86_64.sh"
		FEAT_BINARY_URL_FILENAME_x64="Miniforge3-23.3.1-1-Linux-x86_64.sh"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/conda"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}



feature_miniforge3_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"
	cd "$FEAT_INSTALL_ROOT"
	bash "$FEAT_BINARY_URL_FILENAME" -p $FEAT_INSTALL_ROOT -b -f
	rm -f "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME"

}


fi
