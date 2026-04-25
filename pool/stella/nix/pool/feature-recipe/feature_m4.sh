if [ ! "$_M4_INCLUDED_" = "1" ]; then
_M4_INCLUDED_=1

# For information nixos package recipe : https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/tools/misc/gnum4

# need texinfo to generate doc


feature_m4() {
	FEAT_NAME=m4
	FEAT_LIST_SCHEMA="1_4_19:source 1_4_18:source 1_4_17:source"
	
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_LINK="https://www.gnu.org/software/m4/"
	FEAT_DESC="GNU M4 is an implementation of the traditional Unix macro processor."
	
}


feature_m4_1_4_19() {
	FEAT_VERSION="1_4_19"

	FEAT_SOURCE_DEPENDENCIES="texinfo"

	# nixos recipe for 1_4_19  https://github.com/NixOS/nixpkgs/blob/6d9ed0ec711baac84e3bfc8885180d402877af90/pkgs/development/tools/misc/gnum4/default.nix

	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.gz"
	FEAT_SOURCE_URL_FILENAME="m4-1.4.19.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_m4_patch_for_m4_1_4_19"

	FEAT_TEST="m4"
	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/bin/${FEAT_TEST}"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/bin"
}

feature_m4_1_4_18() {
	FEAT_VERSION="1_4_18"

	FEAT_SOURCE_DEPENDENCIES="texinfo"

	# nixos recipe for 1_4_18 https://github.com/NixOS/nixpkgs/blob/6f04cd0e6967bc2a426b209fa700b3a3dbb1dbc3/pkgs/development/tools/misc/gnum4/default.nix

	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz"
	FEAT_SOURCE_URL_FILENAME="m4-1.4.18.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_m4_patch_for_m4_1_4_18"

	FEAT_TEST="m4"
	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/bin/${FEAT_TEST}"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/bin"
}

feature_m4_1_4_17() {
	FEAT_VERSION="1_4_17"

	FEAT_SOURCE_DEPENDENCIES="texinfo"


	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/m4/m4-1.4.17.tar.gz"
	FEAT_SOURCE_URL_FILENAME="m4-1.4.17.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_m4_patch_for_m4_1_4_17"

	FEAT_TEST="m4"
	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/bin/${FEAT_TEST}"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/bin"
}



feature_m4_patch_for_m4_1_4_19() {
	# debian patches https://sources.debian.org/patches/m4/1.4.19-4/
	# see list https://sources.debian.org/src/m4/1.4.19-4/debian/patches/series/
	patches_url="https://sources.debian.org/data/main/m/m4/1.4.19-4/debian/patches"
	patches_list="01-remove-date-from-m4-texinfo-file.patch 02-add-support-for-loongarch.patch"

	for p in $patches_list; do
		echo "---- begin apply patch $p"
		__get_resource "patch $p" "${patches_url}/${p}" "HTTP" "$SRC_DIR" "FORCE_NAME ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}"
		cd "$SRC_DIR"
		patch -Np1 < ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}
		echo "---- end patch $p"
	done

	
	
	# ubuntu patches https://launchpad.net/ubuntu/+source/m4/+changelog

	# nixos patches
	# https://github.com/NixOS/nixpkgs/blob/6d9ed0ec711baac84e3bfc8885180d402877af90/pkgs/development/tools/misc/gnum4/default.nix#L17C2-L17C84
	# https://gitweb.gentoo.org/repo/gentoo.git/tree/sys-devel/m4/m4-1.4.19-r1.ebuild
	# avoid error : aclocal-1.16 not found
	# apply only if 02-add-support-for-loongarch.patch (and other patches ?) is applied
	cd "$SRC_DIR"
	touch "$SRC_DIR/aclocal.m4" "$SRC_DIR/lib/config.hin" "$SRC_DIR/configure" "$SRC_DIR/doc/stamp-vti" || die
    find . -name Makefile.in -exec touch {} + || die

}

feature_m4_patch_for_m4_1_4_18() {

	# debian patches : https://sources.debian.org/patches/m4/1.4.18-5/
	# see list https://sources.debian.org/src/m4/1.4.18-5/debian/patches/series/
	patches_url="https://sources.debian.org/data/main/m/m4/1.4.18-5/debian/patches"
	patches_list="01-fix-ftbfs-with-glibc-2.28.patch 02-documentencoding.patch 03-remove-date-from-m4-texinfo-file.patch"

	for p in $patches_list; do
		echo "---- begin apply patch $p"
		__get_resource "patch $p" "${patches_url}/${p}" "HTTP" "$SRC_DIR" "FORCE_NAME ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}"
		cd "$SRC_DIR"
		patch -Np1 < ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}
		echo "---- end patch $p"
	done

	# ubuntu patches https://launchpad.net/ubuntu/+source/m4/+changelog

	# patch 04-fix-sigstksz.patch
	# patch for error : missing binary operator before token "("
	# https://bugs.launchpad.net/ubuntu/+source/m4/+bug/1939909
	# https://lists.gnu.org/archive/html/bug-m4/2021-03/msg00000.html
	__get_resource "patch 04-fix-sigstksz.patch" "https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/m4/1.4.18-5ubuntu1/m4_1.4.18-5ubuntu1.debian.tar.xz" "HTTP_ZIP" "$SRC_DIR/m4_1.4.18-5ubuntu1.debian" "FORCE_NAME m4_1.4.18-5ubuntu1.debian.tar.xz"
	cp "$SRC_DIR/m4_1.4.18-5ubuntu1.debian/debian/patches/04-fix-sigstksz.patch" "$SRC_DIR/m4-patch-04-fix-sigstksz.patch"
	cd "$SRC_DIR"
	patch -Np1 < m4-patch-04-fix-sigstksz.patch



}


feature_m4_patch_for_m4_1_4_17() {

	# debian patches https://sources.debian.org/patches/m4/1.4.17-4/
	# see list https://sources.debian.org/src/m4/1.4.17-4/debian/patches/series/
	patches_url="https://sources.debian.org/data/main/m/m4/1.4.17-4/debian/patches"
	patches_list="01-float-endian-detection 99-config-guess-config-sub"

	for p in $patches_list; do
		echo "---- begin apply patch $p"
		__get_resource "patch $p" "${patches_url}/${p}" "HTTP" "$SRC_DIR" "FORCE_NAME ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}"
		cd "$SRC_DIR"
		patch -Np1 < ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}
		echo "---- end patch $p"
	done



}


feature_m4_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "EXCLUDE_FILTER $INSTALL_DIR/lib|$INSTALL_DIR/share"

}

fi
