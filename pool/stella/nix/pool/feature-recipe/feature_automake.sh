if [ ! "$_AUTOMAKE_INCLUDED_" = "1" ]; then
_AUTOMAKE_INCLUDED_=1

# For information nixos package recipe : https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/tools/misc/automake


# TODO
	# GNU Autoconf is a prerequisite for automake.

feature_automake() {
	FEAT_NAME="automake"
	FEAT_LIST_SCHEMA="1_16_5:source 1_14_1:source 1_14:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_LINK="https://www.gnu.org/software/automake/"
	FEAT_DESC="GNU Automake is a tool for automatically generating Makefile.in files compliant with the GNU Coding Standards."
}

feature_automake_1_16_5() {
	FEAT_VERSION="1_16_5"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/automake/automake-1.16.5.tar.gz"
	FEAT_SOURCE_URL_FILENAME="automake-1.16.5.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_automake_sharedoc_callback"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/automake"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_automake_1_14_1() {
	FEAT_VERSION="1_14_1"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/automake/automake-1.14.1.tar.gz"
	FEAT_SOURCE_URL_FILENAME="automake-1.14.1.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_automake_sharedoc_callback"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/automake"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}

feature_automake_1_14() {
	FEAT_VERSION="1_14"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/automake/automake-1.14.tar.gz"
	FEAT_SOURCE_URL_FILENAME="automake-1.14.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_automake_sharedoc_callback"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/automake"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}

feature_automake_sharedoc_callback() {
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--docdir=$INSTALL_DIR/share/doc/automake-${FEAT_VERSION//_/.}"
}

feature_automake_install_source() {
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
