if [ ! "$_browsh_INCLUDED_" = "1" ]; then
_browsh_INCLUDED_=1



feature_browsh() {
	FEAT_NAME=browsh
	FEAT_LIST_SCHEMA="1_5_0@x64:binary 1_5_0@x86:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="A fully-modern text-based browser, rendering to TTY and browsers "
	FEAT_LINK="https://www.brow.sh"
}




feature_browsh_1_5_0() {
	FEAT_VERSION=1_5_0


	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/browsh-org/browsh/releases/download/v1.5.0/browsh_1.5.0_darwin_amd64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="browsh_1.5.0_darwin_amd64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		FEAT_BINARY_URL_x86="https://github.com/browsh-org/browsh/releases/download/v1.5.0/browsh_1.5.0_darwin_386.tar.gz"
		FEAT_BINARY_URL_FILENAME_x86="browsh_1.5.0_darwin_386.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/browsh-org/browsh/releases/download/v1.5.0/browsh_1.5.0_linux_amd64"
		FEAT_BINARY_URL_FILENAME_x64="browsh_1.5.0_linux_amd64"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		FEAT_BINARY_URL_x86="https://github.com/browsh-org/browsh/releases/download/v1.5.0/browsh_1.5.0_linux_386"
		FEAT_BINARY_URL_FILENAME_x86="browsh_1.5.0_linux_386"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/browsh
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}


feature_browsh_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT"
	[ "$FEAT_BINARY_URL_PROTOCOL" = "HTTP" ] && ln -s "${FEAT_INSTALL_ROOT}/$FEAT_BINARY_URL_FILENAME" "${FEAT_INSTALL_ROOT}/browsh"

}


fi
