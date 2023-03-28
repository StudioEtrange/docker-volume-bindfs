if [ ! "$_libxml2_INCLUDED_" = "1" ]; then
_libxml2_INCLUDED_=1


# Version 2.9.4 : https://github.com/Homebrew/homebrew-core/blob/14387b68008911416401c13b7bac668c3aed9c8e/Formula/libxml2.rb
# Version 2.9.4 : https://github.com/NixOS/nixpkgs/blob/dc13593b9fad3ea3728e2fd32f90841d5ec7662d/pkgs/development/libraries/libxml2/default.nix

feature_libxml2() {
	FEAT_NAME=libxml2

	FEAT_LIST_SCHEMA="2_9_1:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"


}

feature_libxml2_2_9_1() {
	FEAT_VERSION=2_9_1


	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2 libiconv#1_14"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://xmlsoft.org/sources/libxml2-2.9.1.tar.gz
	FEAT_SOURCE_URL_FILENAME=llibxml2-2.9.1.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_libxml2_2_9_1_patch feature_libxml2_link"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libxml2.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_libxml2_link() {
	__link_feature_library "libiconv#1_14"
	__link_feature_library "zlib#^1_2" "FORCE_DYNAMIC"
}

feature_libxml2_2_9_1_patch() {
	__get_resource "libxml2_2_9_1_patch" \
	"http://security.debian.org/debian-security/pool/updates/main/libx/libxml2/libxml2_2.9.1+dfsg1-5+deb8u2.debian.tar.xz" \
	"HTTP_ZIP" "$SRC_DIR/patch" "STRIP"

	__copy_folder_content_into "$SRC_DIR/patch/patches" "$SRC_DIR" "*.patch"
	cd "$SRC_DIR"
	for p in *.patch; do
		[ -f "$p" ] && (
			echo " ** Applying patch $p"
			patch -Np1 -i "$p"
		)
	done
}


feature_libxml2_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"
	__add_toolset "autotools"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--with-sax1 --with-writer --with-schemas --with-threads --with-tree --with-history --without-python"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	# "$BUILD/configure" --prefix=$DEST --bindir=$DEST/bin$BUILD_SUFFIX --libdir=$DEST/lib$BUILD_SUFFIX \
	# CFLAGS="$CFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS" \
	# --with-threads --with-tree --with-history --without-python || err "configure" $?
	# # --with-python #TODO

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "POST_BUILD_STEP check"

}


fi
