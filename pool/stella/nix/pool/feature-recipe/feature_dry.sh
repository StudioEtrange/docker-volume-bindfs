if [ ! "$_dry_INCLUDED_" = "1" ]; then
_dry_INCLUDED_=1

feature_dry() {
	FEAT_NAME="dry"
	FEAT_LIST_SCHEMA="0_13_0@x64:binary 0_11_2@x64:binary 0_13_0@x86:binary 0_11_2@x86:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="A Docker manager for the terminal"
	FEAT_LINK="http://moncho.github.io/dry/ https://github.com/moncho/dry"
}


feature_dry_0_13_0() {
	FEAT_VERSION="0_13_0"


		if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
			FEAT_BINARY_URL_x64="https://github.com/moncho/dry/releases/download/v0.13.0/dry-linux-amd64"
			FEAT_BINARY_URL_FILENAME_x64="dry-linux-amd64.v0.13.0"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"

			FEAT_BINARY_URL_x86="https://github.com/moncho/dry/releases/download/v0.13.0/dry-linux-386"
			FEAT_BINARY_URL_FILENAME_x86="dry-linux-386.v0.13.0"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		fi
		if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
			FEAT_BINARY_URL_x64="https://github.com/moncho/dry/releases/download/v0.13.0/dry-darwin-amd64"
			FEAT_BINARY_URL_FILENAME_x64="dry-darwin-amd64.v0.13.0"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"

			FEAT_BINARY_URL_x86="https://github.com/moncho/dry/releases/download/v0.13.0/dry-darwin-386"
			FEAT_BINARY_URL_FILENAME_x86="dry-darwin-386.v0.13.0"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		fi


	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/dry"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}

feature_dry_0_11_2() {
	FEAT_VERSION="0_11_2"


		if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
			FEAT_BINARY_URL_x64="https://github.com/moncho/dry/releases/download/v0.11.2/dry-linux-amd64"
			FEAT_BINARY_URL_FILENAME_x64="dry-linux-amd64.v0.11.2"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"

			FEAT_BINARY_URL_x86="https://github.com/moncho/dry/releases/download/v0.11.2/dry-linux-386"
			FEAT_BINARY_URL_FILENAME_x86="dry-linux-386.v0.11.2"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		fi
		if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
			FEAT_BINARY_URL_x64="https://github.com/moncho/dry/releases/download/v0.11.2/dry-darwin-amd64"
			FEAT_BINARY_URL_FILENAME_x64="dry-darwin-amd64.v0.11.2"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"

			FEAT_BINARY_URL_x86="https://github.com/moncho/dry/releases/download/v0.11.2/dry-darwin-386"
			FEAT_BINARY_URL_FILENAME_x86="dry-darwin-386.v0.11.2"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		fi


	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/dry"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}


feature_dry_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "FORCE_NAME $FEAT_BINARY_URL_FILENAME"

	mv "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" "${FEAT_INSTALL_ROOT}/dry"
	chmod +x ${FEAT_INSTALL_ROOT}/dry
}


fi
