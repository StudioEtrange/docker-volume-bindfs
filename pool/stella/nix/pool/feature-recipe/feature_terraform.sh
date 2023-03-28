if [ ! "$_TERRAFORM_INCLUDED_" = "1" ]; then
_TERRAFORM_INCLUDED_=1




feature_terraform() {

	FEAT_NAME=terraform
	[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && FEAT_LIST_SCHEMA="0_11_7@x64:binary 0_9_6@x64:binary 0_9_4@x64:binary"
	[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && FEAT_LIST_SCHEMA="0_11_7@x64:binary 0_11_7@x86:binary 0_9_6@x64:binary 0_9_6@x86:binary 0_9_4@x64:binary 0_9_4@x86:binary"
	FEAT_DEFAULT_ARCH=x64
	FEAT_DEFAULT_FLAVOUR="binary"
}

feature_terraform_0_11_7() {
	FEAT_VERSION=0_11_7

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_darwin_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=terraform_0.11.7_darwin_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=terraform_0.11.7_linux_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
		FEAT_BINARY_URL_x86=https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_386.zip
		FEAT_BINARY_URL_FILENAME_x86=terraform_0.11.7_linux_386.zip
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/terraform
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}

feature_terraform_0_9_6() {
	FEAT_VERSION=0_9_6

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/terraform/0.9.6/terraform_0.9.6_darwin_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=terraform_0.9.6_darwin_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/terraform/0.9.6/terraform_0.9.6_linux_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=terraform_0.9.6_linux_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
		FEAT_BINARY_URL_x86=https://releases.hashicorp.com/terraform/0.9.6/terraform_0.9.6_linux_386.zip
		FEAT_BINARY_URL_FILENAME_x86=terraform_0.9.6_linux_386.zip
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/terraform
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_terraform_0_9_4() {
	FEAT_VERSION=0_9_4

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/terraform/0.9.4/terraform_0.9.4_darwin_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=terraform_0.9.4_darwin_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/terraform/0.9.4/terraform_0.9.4_linux_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=terraform_0.9.4_linux_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
		FEAT_BINARY_URL_x86=https://releases.hashicorp.com/terraform/0.9.4/terraform_0.9.4_linux_386.zip
		FEAT_BINARY_URL_FILENAME_x86=terraform_0.9.4_linux_386.zip
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/terraform
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


# -----------------------------------------
feature_terraform_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"


}




fi
