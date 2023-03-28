if [ ! "$_consul_INCLUDED_" = "1" ]; then
_consul_INCLUDED_=1



feature_consul() {
	FEAT_NAME=consul
	FEAT_LIST_SCHEMA="1_4_4@x64:binary 1_4_4@x86:binary 1_4_0@x64:binary 1_4_0@x86:binary 0_6_3@x64:binary 0_6_3@x86:binary"
	FEAT_DEFAULT_ARCH=x64
	FEAT_DEFAULT_FLAVOUR="binary"
}


feature_consul_1_4_4() {
	FEAT_VERSION=1_4_4
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86=https://releases.hashicorp.com/consul/1.4.4/consul_1.4.4_linux_386.zip
		FEAT_BINARY_URL_FILENAME_x86=consul_1.4.4_linux_386.zip
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/consul/1.4.4/consul_1.4.4_linux_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=consul_1.4.4_linux_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=https://releases.hashicorp.com/consul/1.4.4/consul_1.4.4_darwin_386.zip
		FEAT_BINARY_URL_FILENAME_x86=consul_1.4.4_darwin_386.zip
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/consul/1.4.4/consul_1.4.4_darwin_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=consul_1.4.4_darwin_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/consul
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_consul_1_4_0() {
	FEAT_VERSION=1_4_0
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86=https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_386.zip
		FEAT_BINARY_URL_FILENAME_x86=consul_1.4.0_linux_386.zip
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=consul_1.4.0_linux_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_darwin_386.zip
		FEAT_BINARY_URL_FILENAME_x86=consul_1.4.0_darwin_386.zip
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_darwin_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=consul_1.4.0_darwin_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/consul
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_consul_0_6_3() {
	FEAT_VERSION=0_6_3
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86=https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_linux_386.zip
		FEAT_BINARY_URL_FILENAME_x86=consul_0.6.3_linux_386.zip
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_linux_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=consul_0.6.3_linux_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_darwin_386.zip
		FEAT_BINARY_URL_FILENAME_x86=consul_0.6.3_darwin_386.zip
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_darwin_amd64.zip
		FEAT_BINARY_URL_FILENAME_x64=consul_0.6.3_darwin_amd64.zip
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/consul
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}



feature_consul_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP"

}


fi
