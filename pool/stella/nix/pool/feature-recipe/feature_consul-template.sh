if [ ! "$_consultemplate_INCLUDED_" = "1" ]; then
_consultemplate_INCLUDED_=1



feature_consul-template() {
	FEAT_NAME=consul-template
	FEAT_LIST_SCHEMA="0_19_4@x64:binary 0_19_4@x86:binary"
	FEAT_DEFAULT_ARCH=x64
	FEAT_DEFAULT_FLAVOUR="binary"
}


feature_consul-template_0_19_4() {
	FEAT_VERSION=0_19_4
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86=https://releases.hashicorp.com/consul-template/0.19.4/consul-template_0.19.4_linux_386.tgz
		FEAT_BINARY_URL_FILENAME_x86=consul-template_0.19.4_linux_386.tgz
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/consul-template/0.19.4/consul-template_0.19.4_linux_amd64.tgz
		FEAT_BINARY_URL_FILENAME_x64=consul-template_0.19.4_linux_amd64.tgz
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=https://releases.hashicorp.com/consul-template/0.19.4/consul-template_0.19.4_darwin_386.tgz
		FEAT_BINARY_URL_FILENAME_x86=consul-template_0.19.4_darwin_386.tgz
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP
		FEAT_BINARY_URL_x64=https://releases.hashicorp.com/consul-template/0.19.4/consul-template_0.19.4_darwin_amd64.tgz
		FEAT_BINARY_URL_FILENAME_x64=consul-template_0.19.4_darwin_amd64.tgz
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/consul-template
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}



feature_consul-template_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT"

}


fi
