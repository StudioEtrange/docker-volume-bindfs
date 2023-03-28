if [ ! "$_AUTOCONF_INCLUDED_" = "1" ]; then
_AUTOCONF_INCLUDED_=1


# TODO
	# GNU M4 is a prerequisite for Autoconf.
	# Perl is a prerequisite for Autoconf.


# # For information nixos package recipe https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/tools/misc/autoconf

feature_autoconf() {
	FEAT_NAME=autoconf
	FEAT_LIST_SCHEMA="2_71:source 2_69:source"
	FEAT_DEFAULT_ARCH=
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

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz"
	FEAT_SOURCE_URL_FILENAME="autoconf-2.69.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"


	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/bin/autoconf"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/bin"

}


feature_autoconf_patch_for_autoconf_2_71() {

	# https://savannah.gnu.org/support/index.php?110521
	__get_resource "autoconf_2_71 patch" "https://git.savannah.gnu.org/cgit/autoconf.git/patch/?id=3a9802d60156809c139e9b4620bf04917e143ee2" "HTTP" "$SRC_DIR" "FORCE_NAME autoconf-patch-fix-race.patch"
	cd "$SRC_DIR"
	patch -Np1 < autoconf-patch-fix-race.patch




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

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

}

fi
