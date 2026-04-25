if [ ! "$_PACKER_INCLUDED_" = "1" ]; then
_PACKER_INCLUDED_=1




feature_packer() {

	FEAT_NAME=packer
	[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && FEAT_LIST_SCHEMA="1_15_2@x64:binary 1_15_2@x86:binary 0_12_3@x64:binary 0_12_3@x86:binary"
	[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && FEAT_LIST_SCHEMA="1_15_2@x64:binary 0_6_0@x64:binary 0_12_3@x64:binary 0_12_3@x86:binary"
	
	FEAT_DESC="Packer is a tool for creating identical machine images for multiple platforms from a single source configuration."
	FEAT_LINK="https://www.packer.io/ https://developer.hashicorp.com/packer https://github.com/hashicorp/packer"
	FEAT_DEFAULT_FLAVOUR="binary"
}


feature_packer_1_15_2() {
	FEAT_VERSION="1_15_2"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_CALLBACK=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://releases.hashicorp.com/packer/1.15.2/packer_1.15.2_darwin_arm64.zip"
			FEAT_BINARY_URL_FILENAME_x64="packer_1.15.2_darwin_arm64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://releases.hashicorp.com/packer/1.15.2/packer_1.15.2_darwin_amd64.zip"
			FEAT_BINARY_URL_FILENAME_x64="packer_1.15.2_darwin_amd64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://releases.hashicorp.com/packer/1.15.2/packer_1.15.2_linux_arm64.zip"
			FEAT_BINARY_URL_FILENAME_x64="packer_1.15.2_linux_arm64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
			FEAT_BINARY_URL_x86="https://releases.hashicorp.com/packer/1.15.2/packer_1.15.2_linux_arm.zip"
			FEAT_BINARY_URL_FILENAME_x86="packer_1.15.2_linux_arm.zip"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://releases.hashicorp.com/packer/1.15.2/packer_1.15.2_linux_amd64.zip"
			FEAT_BINARY_URL_FILENAME_x64="packer_1.15.2_linux_amd64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
			FEAT_BINARY_URL_x86="https://releases.hashicorp.com/packer/1.15.2/packer_1.15.2_linux_386.zip"
			FEAT_BINARY_URL_FILENAME_x86="packer_1.15.2_linux_386.zip"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		fi
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/packer"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_packer_0_12_3() {
	FEAT_VERSION="0_12_3"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_CALLBACK=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://releases.hashicorp.com/packer/0.12.3/packer_0.12.3_darwin_amd64.zip"
		FEAT_BINARY_URL_FILENAME_x64="packer_0.12.3_darwin_amd64.zip"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		FEAT_BINARY_URL_x86="https://releases.hashicorp.com/packer/0.12.3/packer_0.12.3_darwin_386.zip"
		FEAT_BINARY_URL_FILENAME_x86="packer_0.12.3_darwin_386.zip"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64=
			FEAT_BINARY_URL_FILENAME_x64=
			FEAT_BINARY_URL_PROTOCOL_x64=
			FEAT_BINARY_URL_x86="https://releases.hashicorp.com/packer/0.12.3/packer_0.12.3_linux_arm.zip"
			FEAT_BINARY_URL_FILENAME_x86="packer_0.12.3_linux_arm.zip"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://releases.hashicorp.com/packer/0.12.3/packer_0.12.3_linux_amd64.zip"
			FEAT_BINARY_URL_FILENAME_x64="packer_0.12.3_linux_amd64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
			FEAT_BINARY_URL_x86="https://releases.hashicorp.com/packer/0.12.3/packer_0.12.3_linux_386.zip"
			FEAT_BINARY_URL_FILENAME_x86="packer_0.12.3_linux_386.zip"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		fi
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=	

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/packer"
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
