if [ ! "$_TERRAFORMPROVIDERLIBVIRT_INCLUDED_" = "1" ]; then
_TERRAFORMPROVIDERLIBVIRT_INCLUDED_=1

# https://github.com/dmacvicar/terraform-provider-libvirt
# TODO do not work

feature_terraform_provider_libvirt() {

	FEAT_NAME=terraform_provider_libvirt
	FEAT_LIST_SCHEMA="SNAPSHOT:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_terraform_provider_libvirt_SNAPSHOT() {
	FEAT_VERSION=SNAPSHOT

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/dmacvicar/terraform-provider-libvirt
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=GIT

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/terraform
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}




feature_terraform_provider_libvirt_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	#SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "go-build-chain#1_8_1"

	#__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	#__feature_callback
	#__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

	#__link_feature_library "libvirt" "USE_PKG_CONFIG"
	__link_feature_library "libvirt"
	#__add_toolset "go-build-chain#1_8_1"

	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

	cd $INSTALL_DIR

	# TODO see CGO flags https://golang.org/cmd/cgo/
	GOPATH="$INSTALL_DIR" \
	CGO_CFLAGS=$STELLA_C_CXX_FLAGS CGO_CPPFLAGS=$STELLA_CPP_FLAGS CGO_CXXFLAGS=$STELLA_C_CXX_FLAGS CGO_LDFLAGS=$STELLA_LINK_FLAGS \
		go get github.com/dmacvicar/terraform-provider-libvirt

	__end_manual_build

}






fi
