if [ ! "$_LIBSOUNDIO_INCLUDED_" = "1" ]; then
_LIBSOUNDIO_INCLUDED_=1


feature_libsoundio() {
	FEAT_NAME="libsoundio"
	FEAT_LIST_SCHEMA="latest_homebrew:binary"
	FEAT_DEFAULT_FLAVOUR="binary"
	FEAT_DESC="Cross-platform audio input and output"
	FEAT_LINK="https://github.com/andrewrk/libsoundio http://libsound.io https://formulae.brew.sh/formula/libsoundio"
}

feature_libsoundio_latest_homebrew() {
	FEAT_VERSION="latest"

	FEAT_BINARY_URL="libsoundio"
	FEAT_BINARY_URL_PROTOCOL="HOMEBREW_BOTTLE"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/sio_list_devices"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin:$FEAT_INSTALL_ROOT/lib"
}

feature_libsoundio_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT"

}

fi
