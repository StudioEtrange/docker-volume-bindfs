if [ ! "$_BRUSH_INCLUDED_" = "1" ]; then
_BRUSH_INCLUDED_=1


feature_brush() {
	FEAT_NAME="brush"
	FEAT_LIST_SCHEMA="0_2_20@x64:binary"
	# set FEAT_DEFAULT_ARCH if there is x64 (64bits) or x86 (32 bits to be made) versions is the FEAT_LIST_SCHEMA. FEAT_DEFAULT_ARCH will force to use one version over the other when both are available and none have been requested
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="brush (Bo(u)rn(e) RUsty SHell) is a POSIX- and bash-compatible shell, implemented in Rust."
	FEAT_LINK="https://github.com/reubeno/brush https://brush.sh/"
}




feature_brush_0_2_20() {

	FEAT_VERSION="0_2_20"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/reubeno/brush/releases/download/brush-shell-v0.2.20/brush-x86_64-unknown-linux-gnu.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="brush-x86_64-unknown-linux-gnu_${FEAT_VERSION}.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/reubeno/brush/releases/download/brush-shell-v0.2.20/brush-x86_64-apple-darwin.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="brush-x86_64-apple-darwin_${FEAT_VERSION}.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/reubeno/brush/releases/download/brush-shell-v0.2.20/brush-aarch64-apple-darwin.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="brush-aarch64-apple-darwin_${FEAT_VERSION}.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	# callback are list of functions
	# manual callback (with feature_callback)
	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	# automatic callback each time feature is initialized, to init env var
	FEAT_ENV_CALLBACK=

	# List of files to test if feature is installed
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/brush"
	# PATH to add to system PATH
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"
}



feature_brush_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"

	__feature_callback

}





fi
