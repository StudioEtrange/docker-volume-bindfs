if [ ! "$_binutils_INCLUDED_" = "1" ]; then
_binutils_INCLUDED_=1

# NOTE : need zlib

# https://github.com/Homebrew/homebrew-core/blob/master/Formula/binutils.rb

feature_binutils() {
	FEAT_NAME="binutils"
	FEAT_LIST_SCHEMA="2_32:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="The GNU Binutils are a collection of binary tools"
	FEAT_LINK="https://www.gnu.org/software/binutils/binutils.html"
}

feature_binutils_2_32() {
	FEAT_VERSION="2_32"


	FEAT_SOURCE_DEPENDENCIES="FORCE_ORIGIN_SYSTEM zlib"
	FEAT_BINARY_DEPENDENCIES=
	FEAT_SOURCE_URL="https://ftp.gnu.org/gnu/binutils/binutils-2.32.tar.gz"
	FEAT_SOURCE_URL_FILENAME="binutils-2.32.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/objdump
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_binutils_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	# "--prefix=#{prefix}",
  #                          "--infodir=#{info}",
  #                          "--mandir=#{man}",
	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-debug --disable-dependency-tracking --enable-deterministic-archives --disable-werror --enable-interwork --enable-multilib --enable-64-bit-bfd --enable-targets=all"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

}


fi
