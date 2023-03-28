if [ ! "$_gcc_INCLUDED_" = "1" ]; then
_gcc_INCLUDED_=1

# http://llvm.org/docs/GettingStarted.html#requirements
# https://github.com/Homebrew/homebrew-versions/blob/master/gcc48.rb
# http://stackoverflow.com/questions/9450394/how-to-install-gcc-piece-by-piece-with-gmp-mpfr-mpc-elf-without-shared-libra

# NOTE : need g++

feature_gcc() {
	FEAT_NAME=gcc
	FEAT_LIST_SCHEMA="4_8_5:source 7_3_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_gcc_4_8_5() {
	FEAT_VERSION=4_8_5


	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/gcc/gcc-4.8.5/gcc-4.8.5.tar.bz2"
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_gcc_add_resource
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/gcc
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

	# from contrib/download_prerequisites file
	FEAT_ADD_RESOURCES="mpfr https://ftp.gnu.org/gnu/mpfr/mpfr-2.4.2.tar.gz \
	gmp https://ftp.gnu.org/gnu/gmp/gmp-4.3.2.tar.gz \
	mpc http://ftp.vim.org/languages/gcc/infrastructure/mpc-0.8.1.tar.gz"
}
#http://llvm.org/releases/3.9.0/test-suite-3.9.0.src.tar.xz \

feature_gcc_7_3_0() {
	FEAT_VERSION=7_3_0


	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/gcc/gcc-7.3.0/gcc-7.3.0.tar.gz"
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_gcc_add_resource
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/gcc
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

	# from contrib/download_prerequisites file
	FEAT_ADD_RESOURCES="mpfr https://ftp.gnu.org/gnu/mpfr/mpfr-3.1.4.tar.bz2 \
	gmp https://ftp.gnu.org/gnu/gmp/gmp-6.1.0.tar.bz2 \
	mpc https://ftp.gnu.org/gnu/mpc//mpc-1.0.3.tar.gz \
	isl http://ftp.vim.org/languages/gcc/infrastructure/isl-0.16.1.tar.bz2"
}

feature_gcc_add_resource() {
	local _target_folder=
	for t in $FEAT_ADD_RESOURCES; do
		if [ "$_target_folder" = "" ]; then
			_target_folder=$SRC_DIR/$t
			continue
		fi
		__get_resource "$FEAT_NAME" "$t" "$FEAT_SOURCE_URL_PROTOCOL" "$_target_folder" "DEST_ERASE STRIP"
		_target_folder=
	done
}

feature_gcc_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__set_toolset "STANDARD"
	__add_toolset "autotools"
	__check_toolset "C++"

  __feature_callback

	__set_build_mode "LINK_FLAGS_DEFAULT" "OFF"

  AUTO_INSTALL_CONF_FLAG_PREFIX=
  AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-multilib --enable-languages=c,c++"
  AUTO_INSTALL_BUILD_FLAG_PREFIX=
  AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD"

}


fi
