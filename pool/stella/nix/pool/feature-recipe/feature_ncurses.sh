# shellcheck shell=bash
# shellcheck disable=SC2034
if [ ! "$_NCURSES_INCLUDED_" = "1" ]; then
_NCURSES_INCLUDED_=1


# note : 'w' in ncursesw means wide encoding
# https://www.gnu.org/software/ncurses/

feature_ncurses() {
	FEAT_NAME="ncurses"
	FEAT_LIST_SCHEMA="6_5:source 6_4:source 6_3:source 6_2:source 6_1:source 6_0:source 5_9:source"
	
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="ncurses is a programming library providing an API that allows the programmer to write text-based user interfaces in a terminal-independent manner."
	FEAT_LINK="https://invisible-island.net/ncurses/ http://ftp.gnu.org/gnu/ncurses/"
}



feature_ncurses_6_5() {
	FEAT_VERSION="6_5"

	# This release is designed to be source-compatible with ncurses 5.0 through 6.4; providing extensions to the application binary interface (ABI).
	# Although the source can still be configured to support the ncurses 5 ABI, the reason for the release is to reflect improvements to the ncurses 6 ABI and the supporting utility programs.
	FEAT_SOURCE_URL="http://ftp.gnu.org/gnu/ncurses/ncurses-6.5.tar.gz"
	FEAT_SOURCE_URL_FILENAME="ncurses-6.5.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_ncurses_patch"
	FEAT_PATCHES_URL="https://invisible-island.net/archives/ncurses/6.5/dev-patches.zip"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/ncursesw6-config $FEAT_INSTALL_ROOT/bin/ncurses6-config"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}

feature_ncurses_6_4() {
	FEAT_VERSION="6_4"

	FEAT_SOURCE_URL="http://ftp.gnu.org/gnu/ncurses/ncurses-6.4.tar.gz"
	FEAT_SOURCE_URL_FILENAME="ncurses-6.4.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_ncurses_patch"
	FEAT_PATCHES_URL="https://invisible-island.net/archives/ncurses/6.4/dev-patches.zip"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/ncursesw6-config $FEAT_INSTALL_ROOT/bin/ncurses6-config"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_ncurses_6_3() {
	FEAT_VERSION="6_3"

	FEAT_SOURCE_URL="http://ftp.gnu.org/gnu/ncurses/ncurses-6.3.tar.gz"
	FEAT_SOURCE_URL_FILENAME="ncurses-6.3.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_ncurses_patch"
	FEAT_PATCHES_URL="https://invisible-island.net/archives/ncurses/6.3/dev-patches.zip"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/ncursesw6-config $FEAT_INSTALL_ROOT/bin/ncurses6-config"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}

feature_ncurses_6_2() {
	FEAT_VERSION="6_2"

	FEAT_SOURCE_URL="http://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz"
	FEAT_SOURCE_URL_FILENAME="ncurses-6.2.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_ncurses_patch"
	FEAT_PATCHES_URL="https://invisible-island.net/archives/ncurses/6.2/dev-patches.zip"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/ncursesw6-config $FEAT_INSTALL_ROOT/bin/ncurses6-config"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}

feature_ncurses_6_1() {
	FEAT_VERSION="6_1"

	FEAT_SOURCE_URL="http://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz"
	FEAT_SOURCE_URL_FILENAME="ncurses-6.1.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_ncurses_patch"
	FEAT_PATCHES_URL="https://invisible-island.net/archives/ncurses/6.1/dev-patches.zip"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/ncursesw6-config $FEAT_INSTALL_ROOT/bin/ncurses6-config"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_ncurses_6_0() {
	FEAT_VERSION="6_0"

	FEAT_SOURCE_URL="http://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz"
	FEAT_SOURCE_URL_FILENAME="ncurses-6.0.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_ncurses_patch"
	FEAT_PATCHES_URL="https://invisible-island.net/archives/ncurses/6.0/dev-patches.zip"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/ncursesw6-config $FEAT_INSTALL_ROOT/bin/ncurses6-config"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_ncurses_5_9() {
	FEAT_VERSION="5_9"

	FEAT_SOURCE_URL="http://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz"
	FEAT_SOURCE_URL_FILENAME="ncurses-5.9.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="feature_ncurses_patch"
	FEAT_PATCHES_URL="https://invisible-island.net/archives/ncurses/5.9/dev-patches.zip"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/tput"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}




feature_ncurses_patch() {

	if [ ! -z "$FEAT_PATCHES_URL" ]; then
		rm -Rf "$SRC_DIR/patches"
		mkdir -p "$SRC_DIR/patches"

		__get_resource "patches" "$FEAT_PATCHES_URL" "HTTP_ZIP" "$SRC_DIR/patches"
		for p in $SRC_DIR/patches/*.patch.gz; do
			__uncompress "${p}" "$SRC_DIR/patches"
		done

		cd $SRC_DIR
		for p in $SRC_DIR/patches/*.patch; do
			echo "---- begin apply patch $p"
			# --batch answser "no" by deafault to question
			patch -Np1 --batch --silent < ${p}
			echo "---- end patch $p"
		done
	else
		echo "WARN : no patch found to apply"
	fi
}


feature_ncurses_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && __set_build_mode "RPATH" "ADD_FIRST" "$FEAT_INSTALL_ROOT/lib"

	__feature_callback


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
            --without-debug       \
			--disable-widec" # disable wide encoding
            #--enable-pc-files"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "EXCLUDE_FILTER $INSTALL_DIR/lib/terminfo|$INSTALL_DIR/share|$INSTALL_DIR/man"



}


fi
