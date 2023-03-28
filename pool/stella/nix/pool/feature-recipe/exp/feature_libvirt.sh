if [ ! "$_libvirt_INCLUDED_" = "1" ]; then
_libvirt_INCLUDED_=1

# https://github.com/Homebrew/homebrew-core/blob/master/Formula/libvirt.rb
# http://empt1e.blogspot.fr/2016/12/building-libvirt-from-git-on-macos.html
feature_libvirt() {
	FEAT_NAME=libvirt
	FEAT_LIST_SCHEMA="3_2_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_libvirt_3_2_0() {
	FEAT_VERSION=3_2_0
	FEAT_SOURCE_DEPENDENCIES="yajl#2_1_0 libxml2#2_9_1 curl#7_36_0"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://libvirt.org/sources/libvirt-3.2.0.tar.xz
	FEAT_SOURCE_URL_FILENAME=libvirt-3.2.0.tar.xz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_libvirt_source_callback
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/virsh
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin:"$FEAT_INSTALL_ROOT"/sbin

}



feature_libvirt_source_callback() {
	__link_feature_library "yajl"
	__link_feature_library "curl" "GET_FLAGS _curl LIBS_NAME curl NO_SET_FLAGS"
	export CURL_CFLAGS="$_curl_C_CXX_FLAGS $_curl_CPP_FLAGS"
	export CURL_LIBS="$_curl_LINK_FLAGS"

	__link_feature_library "libxml2" "USE_PKG_CONFIG"
}


feature_libvirt_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__set_toolset "STANDARD"
	#__add_toolset "autotools"
	__add_toolset "pkgconfig"





	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--with-esx \
	      --with-init-script=none \
	      --with-remote \
	      --with-test \
	      --with-vbox \
	      --with-vmware \
	      --with-yajl \
	      --with-qemu"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "SOURCE_KEEP"




}


fi
