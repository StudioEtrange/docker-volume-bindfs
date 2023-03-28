if [ ! "$_readline_INCLUDED_" = "1" ]; then
_readline_INCLUDED_=1

# TODO : depend on ncurses


feature_readline() {
	FEAT_NAME=readline
	FEAT_LIST_SCHEMA="6_3_8:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}


feature_readline_6_3_8() {
	FEAT_VERSION=6_3_8
	FEAT_SOURCE_DEPENDENCIES="ncurses#6_0"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://ftpmirror.gnu.org/readline/readline-6.3.tar.gz
	FEAT_SOURCE_URL_FILENAME=readline-6.3.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_readline_6_3_patch feature_readline_link"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libreadline.a
	FEAT_SEARCH_PATH=
}

feature_readline_link() {
	__link_feature_library "ncurses#6_0"
}

feature_readline_6_3_patch() {
	__get_resource "readline63 patch" "http://ftpmirror.gnu.org/readline/readline-6.3-patches/readline63-001" "HTTP" "$SRC_DIR"
	__get_resource "readline63 patch" "http://ftpmirror.gnu.org/readline/readline-6.3-patches/readline63-002" "HTTP" "$SRC_DIR"
	__get_resource "readline63 patch" "http://ftpmirror.gnu.org/readline/readline-6.3-patches/readline63-003" "HTTP" "$SRC_DIR"
	__get_resource "readline63 patch" "http://ftpmirror.gnu.org/readline/readline-6.3-patches/readline63-004" "HTTP" "$SRC_DIR"
	__get_resource "readline63 patch" "http://ftpmirror.gnu.org/readline/readline-6.3-patches/readline63-005" "HTTP" "$SRC_DIR"
	__get_resource "readline63 patch" "http://ftpmirror.gnu.org/readline/readline-6.3-patches/readline63-006" "HTTP" "$SRC_DIR"
	__get_resource "readline63 patch" "http://ftpmirror.gnu.org/readline/readline-6.3-patches/readline63-007" "HTTP" "$SRC_DIR"
	__get_resource "readline63 patch" "http://ftpmirror.gnu.org/readline/readline-6.3-patches/readline63-008" "HTTP" "$SRC_DIR"
	cd "$SRC_DIR"
	patch -Np0 < readline63-001
	patch -Np0 < readline63-002
	patch -Np0 < readline63-003
	patch -Np0 < readline63-004
	patch -Np0 < readline63-005
	patch -Np0 < readline63-006
	patch -Np0 < readline63-007
	patch -Np0 < readline63-008
}


feature_readline_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--enable-multibyte"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"


}



fi
