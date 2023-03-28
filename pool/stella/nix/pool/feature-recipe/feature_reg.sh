if [ ! "$_reg_INCLUDED_" = "1" ]; then
_reg_INCLUDED_=1

#https://github.com/genuinetools/reg

feature_reg() {
	FEAT_NAME=reg
	FEAT_LIST_SCHEMA="studioetrange:source 0_16_0@x64:binary 0_16_0@x86:binary 0_13_0@x64:binary 0_13_0@x86:binary 0_9_0@x64:binary 0_9_0@x86:binary"
	FEAT_DEFAULT_ARCH=x64
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="docker registry client"
	FEAT_LINK="https://github.com/genuinetools/reg"
}


feature_reg_studioetrange() {
	FEAT_VERSION="studioetrange"


	FEAT_SOURCE_URL="https://github.com/StudioEtrange/reg/archive/master.zip"
	FEAT_SOURCE_URL_FILENAME="reg-source-studioetrange-$(date +%s).zip"
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
		FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/reg"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_reg_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$FEAT_INSTALL_ROOT/src/reg"
	BUILD_DIR=

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"

	__add_toolset "go-build-chain#1_11_2"

	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"



	# replace github references to build from local
	cd "$SRC_DIR"
	# https://unix.stackexchange.com/a/112024
	find . -type f -name "*.go" -exec sed -i 's,github.com/genuinetools/reg/,reg/,g' {} +
	
	PREFIX="$INSTALL_DIR" GOPATH="$INSTALL_DIR" make build install

	__end_manual_build

}


feature_reg_0_16_0() {
	FEAT_VERSION=0_16_0

	# Properties for BINARY flavour
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86="https://github.com/genuinetools/reg/releases/download/v0.16.0/reg-darwin-386"
		FEAT_BINARY_URL_FILENAME_x86="reg-darwin-386-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/genuinetools/reg/releases/download/v0.16.0/reg-darwin-amd64"
		FEAT_BINARY_URL_FILENAME_x64="reg-darwin-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86="https://github.com/genuinetools/reg/releases/download/v0.16.0/reg-linux-386"
		FEAT_BINARY_URL_FILENAME_x86="reg-linux-386-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/genuinetools/reg/releases/download/v0.16.0/reg-linux-amd64"
		FEAT_BINARY_URL_FILENAME_x64="reg-linux-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi


	# List of files to test if feature is installed
	FEAT_INSTALL_TEST=$FEAT_INSTALL_ROOT/reg
	# PATH to add to system PATH
	FEAT_SEARCH_PATH=$FEAT_INSTALL_ROOT

}


feature_reg_0_13_0() {
	FEAT_VERSION=0_13_0

	# Dependencies
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	# Properties for BINARY flavour
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86="https://github.com/genuinetools/reg/releases/download/v0.13.0/reg-darwin-386"
		FEAT_BINARY_URL_FILENAME_x86="reg-darwin-386-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/genuinetools/reg/releases/download/v0.13.0/reg-darwin-amd64"
		FEAT_BINARY_URL_FILENAME_x64="reg-darwin-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86="https://github.com/genuinetools/reg/releases/download/v0.13.0/reg-linux-386"
		FEAT_BINARY_URL_FILENAME_x86="reg-linux-386-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/genuinetools/reg/releases/download/v0.13.0/reg-linux-amd64"
		FEAT_BINARY_URL_FILENAME_x64="reg-linux-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi


	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	# List of files to test if feature is installed
	FEAT_INSTALL_TEST=$FEAT_INSTALL_ROOT/reg
	# PATH to add to system PATH
	FEAT_SEARCH_PATH=$FEAT_INSTALL_ROOT

}



feature_reg_0_9_0() {
	FEAT_VERSION=0_9_0

	# Dependencies
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	# Properties for BINARY flavour
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86="https://github.com/genuinetools/reg/releases/download/v0.9.0/reg-darwin-386"
		FEAT_BINARY_URL_FILENAME_x86="reg-darwin-386-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/genuinetools/reg/releases/download/v0.9.0/reg-darwin-amd64"
		FEAT_BINARY_URL_FILENAME_x64="reg-darwin-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86="https://github.com/genuinetools/reg/releases/download/v0.9.0/reg-linux-386"
		FEAT_BINARY_URL_FILENAME_x86="reg-linux-386-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/genuinetools/reg/releases/download/v0.9.0/reg-linux-amd64"
		FEAT_BINARY_URL_FILENAME_x64="reg-linux-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi


	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	# List of files to test if feature is installed
	FEAT_INSTALL_TEST=$FEAT_INSTALL_ROOT/reg
	# PATH to add to system PATH
	FEAT_SEARCH_PATH=$FEAT_INSTALL_ROOT

}


feature_reg_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE FORCE_NAME $FEAT_BINARY_URL_FILENAME"
	mv -f "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME" "$FEAT_INSTALL_ROOT/reg"
	chmod +x "$FEAT_INSTALL_ROOT/reg"

}



fi
