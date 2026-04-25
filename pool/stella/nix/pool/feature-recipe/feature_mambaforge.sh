if [ ! "$_mambaforge_INCLUDED_" = "1" ]; then
_mambaforge_INCLUDED_=1

# deprecated use miniforge3

# mambaforge releases are into https://github.com/conda-forge/miniforge can install different python env management tools
# Miniforge and Mambaforge are identical "That said, if you had to start using one today, we recommend to stick to Miniforge."
# both connected to conda-forge package repository


# list of versions : https://github.com/conda-forge/miniforge/releases

# As of July 2024, Mambaforge is deprecated. We suggest users switch to Miniforge3 immediately. These installers will be retired from new releases after January 2025.
# With the release of Miniforge3-23.3.1-0, that incorporated the changes in #277, the packages and configuration of Mambaforge and Miniforge3 are now identical. The only difference between the two is the name of the installer and, subsequently, the default installation directory.


feature_mambaforge() {
	FEAT_NAME="mambaforge"
	FEAT_LIST_SCHEMA="26_1_1_3@x64:binary 24_3_0_0@x64:binary 22_11_1_4@x64:binary 4_11_0_0@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"


	FEAT_DESC="Minimal env and package python manager with mamba and conda environment management tool and connected to conda-forge."
	FEAT_LINK="https://github.com/conda-forge/miniforge"
}


feature_mambaforge_26_1_1_3() {
	FEAT_VERSION="26_1_1_3"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/24.3.0-0/Mambaforge-24.3.0-0-Linux-x86_64.sh"
			FEAT_BINARY_URL_FILENAME_x64="Mambaforge-24.3.0-0-Linux-x86_64.sh"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/24.3.0-0/Mambaforge-24.3.0-0-Linux-aarch64.sh"
			FEAT_BINARY_URL_FILENAME_x64="Mambaforge-24.3.0-0-Linux-aarch64.sh"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/24.3.0-0/Mambaforge-24.3.0-0-MacOSX-x86_64.sh"
			FEAT_BINARY_URL_FILENAME_x64="Mambaforge-24.3.0-0-MacOSX-x86_64.sh"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/24.3.0-0/Mambaforge-24.3.0-0-MacOSX-arm64.sh"
			FEAT_BINARY_URL_FILENAME_x64="Mambaforge-24.3.0-0-MacOSX-arm64.sh"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/mamba"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}

feature_mambaforge_24_3_0_0() {
	FEAT_VERSION="24_3_0_0"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/24.3.0-0/Mambaforge-24.3.0-0-Linux-x86_64.sh"
			FEAT_BINARY_URL_FILENAME_x64="Mambaforge-24.3.0-0-Linux-x86_64.sh"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/24.3.0-0/Mambaforge-24.3.0-0-Linux-aarch64.sh"
			FEAT_BINARY_URL_FILENAME_x64="Mambaforge-24.3.0-0-Linux-aarch64.sh"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/24.3.0-0/Mambaforge-24.3.0-0-MacOSX-x86_64.sh"
			FEAT_BINARY_URL_FILENAME_x64="Mambaforge-24.3.0-0-MacOSX-x86_64.sh"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/24.3.0-0/Mambaforge-24.3.0-0-MacOSX-arm64.sh"
			FEAT_BINARY_URL_FILENAME_x64="Mambaforge-24.3.0-0-MacOSX-arm64.sh"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/mamba"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_mambaforge_22_11_1_4() {
	FEAT_VERSION="22_11_1_4"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/22.11.1-4/Mambaforge-22.11.1-4-MacOSX-x86_64.sh"
		FEAT_BINARY_URL_FILENAME_x64="Mambaforge-22.11.1-4-MacOSX-x86_64.sh"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/22.11.1-4/Mambaforge-22.11.1-4-Linux-x86_64.sh"
		FEAT_BINARY_URL_FILENAME_x64="Mambaforge-22.11.1-4-Linux-x86_64.sh"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/mamba"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}

feature_mambaforge_4_11_0_0() {
	FEAT_VERSION="4_11_0_0"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/4.11.0-0/Mambaforge-4.11.0-0-MacOSX-x86_64.sh"
		FEAT_BINARY_URL_FILENAME_x64="Mambaforge-4.11.0-0-MacOSX-x86_64.sh"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/conda-forge/miniforge/releases/download/4.11.0-0/Mambaforge-4.11.0-0-Linux-x86_64.sh"
		FEAT_BINARY_URL_FILENAME_x64="Mambaforge-4.11.0-0-Linux-x86_64.sh"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/mamba"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}



feature_mambaforge_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"
	cd "$FEAT_INSTALL_ROOT"
	bash "$FEAT_BINARY_URL_FILENAME" -p $FEAT_INSTALL_ROOT -b -f
	rm -f "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME"

}


fi
