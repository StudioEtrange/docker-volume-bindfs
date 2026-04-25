if [ ! "$_VHS_INCLUDED_" = "1" ]; then
_VHS_INCLUDED_=1

# VHS requires ttyd and ffmpeg to be installed and available on your PATH.
# VHS also needs to run chromium which needs several dependencies (https://github.com/charmbracelet/vhs/issues/438)

# alternative use docker
#	docker run --rm -v $(PWD):/vhs ghcr.io/charmbracelet/vhs demo.tape;

feature_vhs() {
	FEAT_NAME="vhs"
	FEAT_LIST_SCHEMA="0_11_0@x64:binary 0_11_0@x86:binary"

	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="vhs allows you to write terminal GIFs and asciinema-like videos from a simple script"
	FEAT_LINK="https://github.com/charmbracelet/vhs https://www.charm.sh"
}


feature_vhs_0_11_0() {
	FEAT_VERSION="0_11_0"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/charmbracelet/vhs/releases/download/v0.11.0/vhs_0.11.0_Darwin_x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="vhs_0.11.0_Darwin_x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/charmbracelet/vhs/releases/download/v0.11.0/vhs_0.11.0_Darwin_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="vhs_0.11.0_Darwin_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x86="https://github.com/charmbracelet/vhs/releases/download/v0.11.0/vhs_0.11.0_Linux_i386.tar.gz"
			FEAT_BINARY_URL_FILENAME_x86="vhs_0.11.0_Linux_i386.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
			FEAT_BINARY_URL_x64="https://github.com/charmbracelet/vhs/releases/download/v0.11.0/vhs_0.11.0_Linux_x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="vhs_0.11.0_Linux_x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x86="https://github.com/charmbracelet/vhs/releases/download/v0.11.0/vhs_0.11.0_Linux_arm.tar.gz"
			FEAT_BINARY_URL_FILENAME_x86="vhs_0.11.0_Linux_arm.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
			FEAT_BINARY_URL_x64="https://github.com/charmbracelet/vhs/releases/download/v0.11.0/vhs_0.11.0_Linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="vhs_0.11.0_Linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/vhs"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}


feature_vhs_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"


}


fi
