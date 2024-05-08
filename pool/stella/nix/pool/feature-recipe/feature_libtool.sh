if [ ! "$_LIBTOOL_INCLUDED_" = "1" ]; then
_LIBTOOL_INCLUDED_=1



# For information nixos package recipe : https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/tools/misc/libtool

feature_libtool() {
	FEAT_NAME=libtool
	FEAT_LIST_SCHEMA="2_4_7:source 2_4_2:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_LINK="https://www.gnu.org/software/libtool/"
	FEAT_DESC="GNU Libtool is a generic library support script that hides the complexity of using shared libraries behind a consistent, portable interface."
}




feature_libtool_2_4_7() {
	FEAT_VERSION="2_4_7"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/libtool/libtool-2.4.7.tar.gz"
	FEAT_SOURCE_URL_FILENAME="libtool-2.4.7.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_libtool_patch_for_libtool_2_4_7"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/libtool"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_libtool_2_4_2() {
	FEAT_VERSION="2_4_2"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/libtool/libtool-2.4.2.tar.gz"
	FEAT_SOURCE_URL_FILENAME="libtool-2.4.2.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_libtool_patch_for_libtool_2_4_2"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/libtool"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}




feature_libtool_patch_for_libtool_2_4_7() {

	# debian patches https://sources.debian.org/patches/libtool/2.4.7-7/
	# see list https://sources.debian.org/src/libtool/2.4.7-7/debian/patches/series/
	patches_url="https://sources.debian.org/data/main/libt/libtool/2.4.7-7/debian/patches"
	patches_list="0011-libtool-optimizing-options-parser-hooks.patch link_all_deplibs.patch deplib_binary.patch netbsdelf.patch version_type.patch nopic.patch deplibs_test_disable.patch \
disable-link-order2.patch deplibs-ident.patch man-add-whatis-info.diff no_hostname.patch bootstrap_options.conf version_string.patch grep-spaces.patch libtool-eval-nm.patch \
0030-flang-support.patch 0040-unsafe-eval.patch 0050-documentation.patch 0055-pass-flags-unchanged.patch 0075-remove-dates-from-docs.patch 0080-struct-names.patch \
0085-tcc-path.patch 0090-shell-op.patch"

	for p in $patches_list; do
		echo "---- begin apply patch $p"
		__get_resource "patch $p" "${patches_url}/${p}" "HTTP" "$SRC_DIR" "FORCE_NAME ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}"
		cd "$SRC_DIR"
		patch -Np1 < ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}
		echo "---- end patch $p"
	done

}


feature_libtool_patch_for_libtool_2_4_2() {
	# debian patches https://sources.debian.org/patches/libtool/2.4.2-1.11/
	# see list https://sources.debian.org/src/libtool/2.4.2-1.11/debian/patches/series/
	patches_url="https://sources.debian.org/data/main/libt/libtool/2.4.2-1.11/debian/patches"
	patches_list="link_all_deplibs.patch deplib_binary.patch netbsdelf.patch version_type.patch nopic.patch deplibs_test_disable.patch \
disable-link-order2.patch deplibs-ident.patch hurd.patch x32.patch ppc64el.patch man-add-whatis-info.diff"

	for p in $patches_list; do
		echo "---- begin apply patch $p"
		__get_resource "patch $p" "${patches_url}/${p}" "HTTP" "$SRC_DIR" "FORCE_NAME ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}"
		cd "$SRC_DIR"
		patch -Np1 < ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}
		echo "---- end patch $p"
	done

}


feature_libtool_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	# allow to disable doc generation (at least for version 2_4_7)
	AUTO_INSTALL_BUILD_FLAG_POSTFIX="HELP2MAN=true"


	__set_build_mode "LINK_FLAGS_DEFAULT" "OFF"
	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "EXCLUDE_FILTER $FEAT_INSTALL_ROOT/share|$FEAT_INSTALL_ROOT/lib|$FEAT_INSTALL_ROOT/include"

	# some scripts call libtoolize as glibtoolize
	if [ -f "$FEAT_INSTALL_ROOT/bin/libtoolize" ]; then
		rm -f "$FEAT_INSTALL_ROOT/bin/glibtoolize"
 		ln -s "$FEAT_INSTALL_ROOT/bin/libtoolize" "$FEAT_INSTALL_ROOT/bin/glibtoolize"
	fi
}

fi
