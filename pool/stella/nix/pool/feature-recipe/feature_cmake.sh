if [ ! "$_CMAKE_INCLUDED_" = "1" ]; then
_CMAKE_INCLUDED_=1

feature_cmake() {

	FEAT_NAME="cmake"
	FEAT_LIST_SCHEMA="4_0_4:source 4_3_1:binary 4_0_4:binary 3_31_9:source 3_31_9:binary 3_12_4:source 3_12_4:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_LINK="https://cmake.org/ https://github.com/Kitware/CMake https://gitlab.kitware.com/cmake/cmake"
	FEAT_DESC="CMake, the cross-platform, open-source build system."
}



feature_cmake_4_3_1() {
	FEAT_VERSION="4_3_1"
	# TODO  needed dependencies
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/Kitware/CMake/releases/download/v4.3.1/cmake-4.3.1.tar.gz"
	FEAT_SOURCE_URL_FILENAME="cmake-4.3.1.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://github.com/Kitware/CMake/releases/download/v4.3.1/cmake-4.3.1-macos-universal.dmg"
		FEAT_BINARY_URL_FILENAME="cmake-4.3.1-macos-universal.dmg"
		FEAT_BINARY_URL_PROTOCOL="HTTP"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL="https://github.com/Kitware/CMake/releases/download/v4.3.1/cmake-4.3.1-linux-x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME="cmake-4.3.1-linux-x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL="https://github.com/Kitware/CMake/releases/download/v4.3.1/cmake-4.3.1-linux-aarch64.tar.gz"
			FEAT_BINARY_URL_FILENAME="cmake-4.3.1-linux-aarch64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/cmake"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		CMAKE_FILE_APP="CMake.app"
	fi
}

feature_cmake_4_0_4() {
	FEAT_VERSION="4_0_4"
	# TODO  needed dependencies
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/Kitware/CMake/releases/download/v4.0.4/cmake-4.0.4.tar.gz"
	FEAT_SOURCE_URL_FILENAME="cmake-4.0.4.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://github.com/Kitware/CMake/releases/download/v4.0.4/cmake-4.0.4-macos-universal.dmg"
		FEAT_BINARY_URL_FILENAME="cmake-4.0.4-macos-universal.dmg"
		FEAT_BINARY_URL_PROTOCOL="HTTP"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL="https://github.com/Kitware/CMake/releases/download/v4.0.4/cmake-4.0.4-linux-x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME="cmake-4.0.4-linux-x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL="https://github.com/Kitware/CMake/releases/download/v4.0.4/cmake-4.0.4-linux-aarch64.tar.gz"
			FEAT_BINARY_URL_FILENAME="cmake-4.0.4-linux-aarch64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/cmake"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		CMAKE_FILE_APP="CMake.app"
	fi
}



feature_cmake_3_31_9() {
	FEAT_VERSION="3_31_9"
	# TODO  needed dependencies
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/Kitware/CMake/releases/download/v3.31.9/cmake-3.31.9.tar.gz"
	FEAT_SOURCE_URL_FILENAME="cmake-3.31.9.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://github.com/Kitware/CMake/releases/download/v3.31.9/cmake-3.31.9-macos-universal.dmg"
		FEAT_BINARY_URL_FILENAME="cmake-3.31.9-macos-universal.dmg"
		FEAT_BINARY_URL_PROTOCOL="HTTP"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL="https://github.com/Kitware/CMake/releases/download/v3.31.9/cmake-3.31.9-linux-x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME="cmake-3.31.9-linux-x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL="https://github.com/Kitware/CMake/releases/download/v3.31.9/cmake-3.31.9-linux-aarch64.tar.gz"
			FEAT_BINARY_URL_FILENAME="cmake-3.31.9-linux-aarch64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/cmake"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		CMAKE_FILE_APP="CMake.app"
	fi
}



feature_cmake_3_12_4() {
	FEAT_VERSION=3_12_4
	# TODO  ** NEED : cURL, libarchive and expat
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/Kitware/CMake/releases/download/v3.12.4/cmake-3.12.4.tar.gz"
	FEAT_SOURCE_URL_FILENAME="cmake-3.12.4.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://github.com/Kitware/CMake/releases/download/v3.12.4/cmake-3.12.4-Darwin-x86_64.dmg"
		FEAT_BINARY_URL_FILENAME="cmake-3.12.4-Darwin-x86_64.dmg"
		FEAT_BINARY_URL_PROTOCOL="HTTP"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL="https://github.com/Kitware/CMake/releases/download/v3.12.4/cmake-3.12.4-Linux-x86_64.tar.gz"
		FEAT_BINARY_URL_FILENAME="cmake-3.12.4-Linux-x86_64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/cmake"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		CMAKE_FILE_APP="CMake.app"
	fi
}




feature_cmake_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"
	BUILD_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-build"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__set_toolset "STANDARD"

	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"
	#__prepare_build "$INSTALL_DIR"

	__del_folder "$BUILD_DIR"
	mkdir -p "$BUILD_DIR"

	cd "$BUILD_DIR"

	chmod +x $SRC_DIR/bootstrap
	$SRC_DIR/bootstrap --prefix="$INSTALL_DIR"
	#cmake "$SRC_DIR" -DTEMPLATE_INSTALL_PREFIX="$INSTALL_DIR"
	#make -j$BUILD_JOB
	make -j$STELLA_NB_CPU
	make install

	__del_folder "$SRC_DIR"
	__del_folder "$BUILD_DIR"


	__inspect_and_fix_build "$INSTALL_DIR" "EXCLUDE_FILTER $INSTALL_DIR/share"

	__end_manual_build
}


feature_cmake_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		__uncompress_dmg "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME" "$FEAT_INSTALL_ROOT"
		rm -Rf "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME"

		ln -s "$FEAT_INSTALL_ROOT/$CMAKE_FILE_APP/Contents/bin" "$FEAT_INSTALL_ROOT/bin"
		ln -s "$FEAT_INSTALL_ROOT/$CMAKE_FILE_APP/Contents/doc" "$FEAT_INSTALL_ROOT/doc"
		ln -s "$FEAT_INSTALL_ROOT/$CMAKE_FILE_APP/Contents/man" "$FEAT_INSTALL_ROOT/man"
		ln -s "$FEAT_INSTALL_ROOT/$CMAKE_FILE_APP/Contents/share" "$FEAT_INSTALL_ROOT/share"
	fi
}


fi
