if [ ! "$_AUTOCONF_INCLUDED_" = "1" ]; then
_AUTOCONF_INCLUDED_=1


# TODO
	# GNU M4 is a prerequisite for Autoconf.
	# Perl is a prerequisite for Autoconf.


# # For information nixos package recipe https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/tools/misc/autoconf

feature_autoconf() {
	FEAT_NAME=autoconf
	FEAT_LIST_SCHEMA="2_71:source 2_69:source"
	
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_LINK="https://www.gnu.org/software/autoconf"
	FEAT_DESC="Autoconf is an extensible package of M4 macros that produce shell scripts to automatically configure software source code packages."
}


feature_autoconf_2_71() {
	FEAT_VERSION="2_71"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/autoconf/autoconf-2.71.tar.gz"
	FEAT_SOURCE_URL_FILENAME="autoconf-2.71.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"


	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_autoconf_patch_for_autoconf_2_71"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/bin/autoconf"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/bin"

}


feature_autoconf_2_69() {
	FEAT_VERSION="2_69"

	FEAT_SOURCE_DEPENDENCIES="texinfo#5_1"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz"
	FEAT_SOURCE_URL_FILENAME="autoconf-2.69.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"


	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_autoconf_patch_for_autoconf_2_69"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/bin/autoconf"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/bin"

}


feature_autoconf_patch_for_autoconf_2_71() {

	# https://savannah.gnu.org/support/index.php?110521
	# https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/tools/misc/autoconf/2.71.nix#L19C7-L19C57
	__get_resource "autoconf_2_71 patch" "https://git.savannah.gnu.org/cgit/autoconf.git/patch/?id=3a9802d60156809c139e9b4620bf04917e143ee2" "HTTP" "$SRC_DIR" "FORCE_NAME autoconf-patch-fix-race.patch"
	cd "$SRC_DIR"
	patch -Np1 < autoconf-patch-fix-race.patch




}

feature_autoconf_patch_for_autoconf_2_69() {

	# debian patches https://sources.debian.org/patches/autoconf/2.69-14/
	# see list https://sources.debian.org/src/autoconf/2.69-14/debian/patches/series/
	patches_url="https://sources.debian.org/data/main/a/autoconf/2.69-14/debian/patches"
	patches_list="atomic.patch stricter-versioning.patch texinfo.patch avoid-undefined-behavior-for-32bit-off_t.patch \
AM_PROG_LIBTOOL.patch add-runstatedir.patch unescaped-left-brace-warning-fix.patch mmap-leak-fix.patch remove-build-date-from-autoconf.texi-clo.patch"

	for p in $patches_list; do
		echo "---- begin apply patch $p"
		__get_resource "patch $p" "${patches_url}/${p}" "HTTP" "$SRC_DIR" "FORCE_NAME ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}"
		cd "$SRC_DIR"
		patch -Np1 < ${FEAT_NAME}_${FEAT_VERSION}-patch-${p}
		echo "---- end patch $p"
	done

}

feature_autoconf_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	__set_toolset "STANDARD"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "EXCLUDE_FILTER $FEAT_INSTALL_ROOT/share|$FEAT_INSTALL_ROOT/lib|$FEAT_INSTALL_ROOT/include"

}

fi
