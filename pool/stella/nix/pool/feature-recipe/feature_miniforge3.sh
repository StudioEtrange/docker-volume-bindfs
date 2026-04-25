if [ ! "$_miniforge3_INCLUDED_" = "1" ]; then
_miniforge3_INCLUDED_=1

# mambaforge releases are into https://github.com/conda-forge/miniforge can install different python env management tools
# Miniforge and Mambaforge are identical "That said, if you had to start using one today, we recommend to stick to Miniforge."
# both connected to conda-forge package repository


# list of versions : https://github.com/conda-forge/miniforge/releases

# With the release of Miniforge3-23.3.1-0, the packages and configuration of Mambaforge and Miniforge3 are now identical. The only difference between the two is the name of the installer and, subsequently, the default installation directory.

# micromamba is a tiny version of the mamba package manager. It is a statically linked C++ executable with a separate command line interface. It does not need a base environment and does not come with a default version of Python.

feature_miniforge3() {
	FEAT_NAME="miniforge3"
	FEAT_LIST_SCHEMA="25_3_1_0@x64:binary 25_3_0_3@x64:binary 23_3_1_1@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Minimal env and package python manager with conda as environment management tool and connected to conda-forge."
	FEAT_LINK="https://github.com/conda-forge/miniforge"
}


feature_miniforge3_25_3_1_0() {
	FEAT_VERSION="25_3_1_0"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/25.3.1-0/Miniforge3-25.3.1-0-Linux-x86_64.sh"
			FEAT_BINARY_URL_FILENAME_x64="Miniforge3-25.3.1-0-Linux-x86_64.sh"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi

		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/25.3.1-0/Miniforge3-25.3.1-0-Linux-aarch64.sh"
			FEAT_BINARY_URL_FILENAME_x64="Miniforge3-25.3.1-0-Linux-aarch64.sh"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/25.3.1-0/Miniforge3-25.3.1-0-MacOSX-x86_64.sh"
			FEAT_BINARY_URL_FILENAME_x64="Miniforge3-25.3.1-0-MacOSX-x86_64.sh"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/25.3.1-0/Miniforge3-25.3.1-0-MacOSX-arm64.sh"
			FEAT_BINARY_URL_FILENAME_x64="Miniforge3-25.3.1-0-MacOSX-arm64.sh"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/mamba"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_miniforge3_25_3_0_3() {
	FEAT_VERSION="25_3_0_3"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/25.3.0-3/Miniforge3-25.3.0-3-Linux-x86_64.sh"
		FEAT_BINARY_URL_FILENAME_x64="Miniforge3-25.3.0-3-Linux-x86_64.sh"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="hhttps://github.com/conda-forge/miniforge/releases/download/25.3.0-3/Miniforge3-25.3.0-3-MacOSX-x86_64.sh"
			FEAT_BINARY_URL_FILENAME_x64="Miniforge3-25.3.0-3-MacOSX-x86_64.sh"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/25.3.0-3/Miniforge3-25.3.0-3-MacOSX-arm64.sh"
			FEAT_BINARY_URL_FILENAME_x64="Miniforge3-25.3.0-3-MacOSX-arm64.sh"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/mamba"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

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
