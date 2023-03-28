# shellcheck shell=bash
# shellcheck disable=SC2034
if [ ! "$_NCURSES_INCLUDED_" = "1" ]; then
_NCURSES_INCLUDED_=1


# note : 'w' in ncursesw means wide encoding
# https://www.gnu.org/software/ncurses/

feature_ncurses() {
	FEAT_NAME="ncurses"
	FEAT_LIST_SCHEMA="6_1:source 6_0:source 5_9:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="ncurses is a programming library providing an API that allows the programmer to write text-based user interfaces in a terminal-independent manner."
	FEAT_LINK="https://invisible-island.net/ncurses/"
}


feature_ncurses_6_1() {
	FEAT_VERSION="6_1"

	FEAT_SOURCE_URL="http://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz"
	FEAT_SOURCE_URL_FILENAME="ncurses-6.1.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_TEST="ncurses6-config"
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/$FEAT_TEST"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_ncurses_6_0() {
	FEAT_VERSION="6_0"

	FEAT_SOURCE_URL="http://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz"
	FEAT_SOURCE_URL_FILENAME="ncurses-6.0.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_TEST="ncurses6-config"
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/$FEAT_TEST"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_ncurses_5_9() {
	FEAT_VERSION="5_9"

	FEAT_SOURCE_URL="http://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz"
	FEAT_SOURCE_URL_FILENAME="ncurses-5.9.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_TEST="ncurses5-config"
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/$FEAT_TEST"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}





feature_ncurses_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && __set_build_mode "RPATH" "ADD_FIRST" "$FEAT_INSTALL_ROOT/lib"

	# with wide encoding
	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="
			--disable-dependency-tracking \
			--with-shared           \
            --without-debug         \
            --enable-widec" # wide encoding
			# --enable-pc-files
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "SOURCE_KEEP NO_FIX NO_CHECK"

	# standard build
	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="
			--disable-dependency-tracking \
			--with-shared           \
            --without-debug"
            #--enable-pc-files"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "EXCLUDE_FILTER /lib/terminfo|/share|/man"



}


fi
