if [ ! "$_NINJA_INCLUDED_" = "1" ]; then
_NINJA_INCLUDED_=1


feature_ninja() {

	FEAT_NAME="ninja"
	FEAT_LIST_SCHEMA="1_9_0:source 1_9_0:binary 1_7_2:source 1_7_2:binary 1_7_1:source 1_7_1:binary 1_6_0:source 1_6_0:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_LINK=
	FEAT_DESC=
}


feature_ninja_1_9_0() {
	FEAT_VERSION=1_9_0

	# TODO echo " ** NEED : python"
	FEAT_SOURCE_DEPENDENCIES="python#2_7_9"

	FEAT_SOURCE_URL="https://github.com/ninja-build/ninja/archive/v1.9.0.tar.gz"
	FEAT_SOURCE_URL_FILENAME="ninja-v1.9.0.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://github.com/ninja-build/ninja/releases/download/v1.9.0/ninja-mac.zip"
		FEAT_BINARY_URL_FILENAME="ninja-mac-v1.9.0.zip"
		FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL="https://github.com/ninja-build/ninja/releases/download/v1.9.0/ninja-linux.zip"
		FEAT_BINARY_URL_FILENAME="ninja-linux-v1.9.0.zip"
		FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"
	fi


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/ninja
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_ninja_1_7_2() {
	FEAT_VERSION=1_7_2

	# TODO echo " ** NEED : python"
	FEAT_SOURCE_DEPENDENCIES="python#2_7_9"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/ninja-build/ninja/archive/v1.7.2.tar.gz
	FEAT_SOURCE_URL_FILENAME=ninja-v1.7.2.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://github.com/ninja-build/ninja/releases/download/v1.7.2/ninja-mac.zip
		FEAT_BINARY_URL_FILENAME=ninja-mac-v1.7.2.zip
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://github.com/ninja-build/ninja/releases/download/v1.7.2/ninja-linux.zip
		FEAT_BINARY_URL_FILENAME=ninja-linux-v1.7.2.zip
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/ninja
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_ninja_1_7_1() {
	FEAT_VERSION=1_7_1

	# TODO echo " ** NEED : python"
	FEAT_SOURCE_DEPENDENCIES="python#2_7_9"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/ninja-build/ninja/archive/v1.7.1.tar.gz
	FEAT_SOURCE_URL_FILENAME=ninja-v1.7.1.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://github.com/ninja-build/ninja/releases/download/v1.7.1/ninja-mac.zip
		FEAT_BINARY_URL_FILENAME=ninja-mac-v1.7.1.zip
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://github.com/ninja-build/ninja/releases/download/v1.7.1/ninja-linux.zip
		FEAT_BINARY_URL_FILENAME=ninja-linux-v1.7.1.zip
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/ninja
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_ninja_1_6_0() {
	FEAT_VERSION=1_6_0

	# TODO echo " ** NEED : python"
	FEAT_SOURCE_DEPENDENCIES="python#2_7_9"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/martine/ninja/archive/v1.6.0.tar.gz
	FEAT_SOURCE_URL_FILENAME=ninja-v1.6.0.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://github.com/martine/ninja/releases/download/v1.6.0/ninja-mac.zip
		FEAT_BINARY_URL_FILENAME=ninja-mac-v1.6.0.zip
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://github.com/martine/ninja/releases/download/v1.6.0/ninja-linux.zip
		FEAT_BINARY_URL_FILENAME=ninja-linux-v1.6.0.zip
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/ninja
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_ninja_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$INSTALL_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"

	cd "$INSTALL_DIR"
	#python ./bootstrap.py
	python ./configure.py --bootstrap
}


feature_ninja_install_binary() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$INSTALL_DIR" "STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"

}


fi
