if [ ! "$_gmp_INCLUDED_" = "1" ]; then
_gmp_INCLUDED_=1

# darwin : https://github.com/Homebrew/homebrew/blob/master/Library/Formula/gmp.rb


feature_gmp() {
	FEAT_NAME=gmp
	FEAT_LIST_SCHEMA="6_0_0a:source"
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_gmp_6_0_0a() {
	FEAT_VERSION=6_0_0a

	FEAT_SOURCE_URL=http://ftpmirror.gnu.org/gmp/gmp-6.0.0a.tar.bz2
	FEAT_SOURCE_URL_FILENAME=ggmp-6.0.0a.tar.bz2
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libgmp.a
}



feature_gmp_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "STRIP"

	# https://gmplib.org/manual/Build-Options.html
	# C++ Support
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--enable-cxx"
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		[ "$STELLA_BUILD_ARCH" = "x64" ] && AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --disable-assembly"
	fi

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "POST_BUILD_STEP install check"

}



fi
