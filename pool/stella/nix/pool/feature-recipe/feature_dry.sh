if [ ! "$_dry_INCLUDED_" = "1" ]; then
_dry_INCLUDED_=1

# https://github.com/moncho/dry

feature_dry() {
	FEAT_NAME=dry
	FEAT_LIST_SCHEMA="0_9_beta_9@x64 0_9_beta_9@x86:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="A Docker manager for the terminal"
	FEAT_LINK="http://moncho.github.io/dry/"
}


feature_dry_0_9_beta_9() {
	FEAT_VERSION="0_9_beta_9"


		if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
			FEAT_BINARY_URL_x64="https://github.com/moncho/dry/releases/download/v0.9-beta.9/dry-linux-amd64"
			FEAT_BINARY_URL_FILENAME_x64="dry-linux-amd64.v0.9-beta.9"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"

			FEAT_BINARY_URL_x86="https://github.com/moncho/dry/releases/download/v0.9-beta.9/dry-linux-386"
			FEAT_BINARY_URL_FILENAME_x86="dry-linux-386.v0.9-beta.9"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		fi
		if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
			FEAT_BINARY_URL_x64="https://github.com/moncho/dry/releases/download/v0.9-beta.9/dry-darwin-amd64"
			FEAT_BINARY_URL_FILENAME_x64="dry-darwin-amd64.v0.9-beta.9"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"

			FEAT_BINARY_URL_x86="https://github.com/moncho/dry/releases/download/v0.9-beta.9/dry-darwin-386"
			FEAT_BINARY_URL_FILENAME_x86="dry-darwin-386.v0.9-beta.9"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		fi


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/dry
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_dry_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT"

	mv "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME" "$FEAT_INSTALL_ROOT/dry"
	chmod +x $FEAT_INSTALL_ROOT/dry
}


fi
