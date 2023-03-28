if [ ! "$_SEVENZIP_INCLUDED_" = "1" ]; then
_SEVENZIP_INCLUDED_=1


#TODO do not work yet
feature_sevenzip() {
	FEAT_NAME=sevenzip
	FEAT_LIST_SCHEMA="9_20_1:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_sevenzip_9_20_1() {
	FEAT_VERSION=9_20_1
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://downloads.sourceforge.net/project/p7zip/p7zip/9.20.1/p7zip_9.20.1_src_all.tar.bz2
	FEAT_SOURCE_URL_FILENAME=p7zip_9.20.1_src_all.tar.bz2
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libz.a
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/lib
}

feature_sevenzip_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"


	__get_resource "sevenzip" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"
	cd "$SRC_DIR"
	make all3
	make DEST_HOME="$INSTALL_DIR" install


    #TODO do not work yet -- use specific makefile for each OS, see https://github.com/Homebrew/homebrew/blob/master/Library/Formula/p7zip.rb

	__end_manual_build
}



fi
