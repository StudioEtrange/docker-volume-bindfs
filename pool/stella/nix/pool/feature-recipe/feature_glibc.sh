if [ ! "$_glibc_INCLUDED_" = "1" ]; then
_glibc_INCLUDED_=1



feature_glibc() {
	FEAT_NAME=glibc
	FEAT_LIST_SCHEMA="2_18:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}



# http://www.linuxfromscratch.org/lfs/view/7.4/chapter06/glibc.html
feature_glibc_2_18() {
	FEAT_VERSION=2_18

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.xz
	FEAT_SOURCE_URL_FILENAME=glibc-2.18.tar.xz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_glibc_2_18_patch
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libc.so
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_glibc_2_18_patch() {
	cd $SRC_DIR
	sed -i -e 's/static __m128i/inline &/' sysdeps/x86_64/multiarch/strstr.c
}

feature_glibc_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-profile --enable-kernel=2.6.32 --libexecdir=$INSTALL_DIR/libexec"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__feature_callback

	__set_build_mode "LINK_FLAGS_DEFAULT" "OFF"

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"


}




fi
