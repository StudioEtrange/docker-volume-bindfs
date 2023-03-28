if [ ! "$_RESTIC_INCLUDED_" = "1" ]; then
_RESTIC_INCLUDED_=1



feature_restic() {

	FEAT_NAME="restic"
	[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && FEAT_LIST_SCHEMA="0_12_0@x64:binary"
	[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && FEAT_LIST_SCHEMA="0_12_0@x64:binary 0_12_0@x86:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	
	FEAT_DESC="restic is a backup program that is fast, efficient and secure."
	FEAT_LINK="https://github.com/restic/restic https://restic.readthedocs.io/"
}

feature_restic_0_12_0() {
	FEAT_VERSION="0_12_0"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/restic/restic/releases/download/v0.12.0/restic_0.12.0_darwin_amd64.bz2"
		FEAT_BINARY_URL_FILENAME_x64="restic_0.12.0_darwin_amd64.bz2"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/restic/restic/releases/download/v0.12.0/restic_0.12.0_linux_amd64.bz2"
		FEAT_BINARY_URL_FILENAME_x64="restic_0.12.0_linux_amd64.bz2"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		FEAT_BINARY_URL_x86="https://github.com/restic/restic/releases/download/v0.12.0/restic_0.12.0_linux_386.bz2"
		FEAT_BINARY_URL_FILENAME_x86="restic_0.12.0_linux_386.bz2"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/restic
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}

# -----------------------------------------
feature_restic_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"
	mv "$FEAT_INSTALL_ROOT"/restic* "$FEAT_INSTALL_ROOT"/restic
}

fi
