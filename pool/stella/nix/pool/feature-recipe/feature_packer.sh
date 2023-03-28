if [ ! "$_PACKER_INCLUDED_" = "1" ]; then
_PACKER_INCLUDED_=1




feature_packer() {

	FEAT_NAME=packer
	FEAT_LIST_SCHEMA="0_6_0@x64:binary 0_6_0@x86:binary 0_7_5@x64:binary 0_7_5@x86:binary"
	FEAT_DEFAULT_ARCH=x64
	FEAT_DEFAULT_FLAVOUR="binary"
}

feature_packer_0_6_0() {
	FEAT_VERSION=0_6_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_CALLBACK=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64=https://dl.bintray.com/mitchellh/packer/0.6.0_darwin_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=packer_0.6.0_darwin_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
		FEAT_BINARY_URL_x86="https://dl.bintray.com/mitchellh/packer/0.6.0_darwin_386.zip"
		FEAT_BINARY_URL_FILENAME_x86="packer_0.6.0_darwin_386.zip"
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64=https://dl.bintray.com/mitchellh/packer/0.6.0_linux_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=packer_0.6.0_linux_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
		FEAT_BINARY_URL_x86=https://dl.bintray.com/mitchellh/packer/0.6.0_linux_386.zip
		FEAT_BINARY_URL_FILENAME_x86=packer_0.6.0_linux_386.zip
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/packer
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_packer_0_7_5() {
	FEAT_VERSION=0_7_5

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_CALLBACK=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64=https://dl.bintray.com/mitchellh/packer/packer_0.7.5_darwin_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=packer_0.7.5_darwin_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
		FEAT_BINARY_URL_x86=https://dl.bintray.com/mitchellh/packer/packer_0.7.5_darwin_386.zip
		FEAT_BINARY_URL_FILENAME_x86=packer_0.7.5_darwin_386.zip
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64=https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=packer_0.7.5_linux_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
		FEAT_BINARY_URL_x86=https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_386.zip
		FEAT_BINARY_URL_FILENAME_x86=packer_0.7.5_linux_386.zip
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/packer
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


# -----------------------------------------
feature_packer_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"

	if [ -d "$FEAT_INSTALL_ROOT" ]; then
		chmod +x $FEAT_INSTALL_ROOT/*
	fi

}




fi
