if [ ! "$_otto_INCLUDED_" = "1" ]; then
_otto_INCLUDED_=1



feature_otto() {
	FEAT_NAME=otto
	FEAT_LIST_SCHEMA="0_2_0@x64:binary 0_2_0@x86:binary"
	FEAT_DEFAULT_ARCH=x64
	FEAT_DEFAULT_FLAVOUR="binary"
}


feature_otto_0_2_0() {
	FEAT_VERSION=0_2_0
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86=https://releases.hashicorp.com/otto/0.2.0/otto_0.2.0_linux_386.zip
		FEAT_BINARY_URL_FILENAME_x86=otto_0.2.0_linux_386.zip
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/otto/0.2.0/otto_0.2.0_linux_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=otto_0.2.0_linux_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=https://releases.hashicorp.com/otto/0.2.0/otto_0.2.0_darwin_386.zip
		FEAT_BINARY_URL_FILENAME_x86=otto_0.2.0_darwin_386.zip
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/otto/0.2.0/otto_0.2.0_darwin_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=otto_0.2.0_darwin_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/otto
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}



feature_otto_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP"

}


fi
