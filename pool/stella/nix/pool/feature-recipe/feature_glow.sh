if [ ! "$_GLOW_INCLUDED_" = "1" ]; then
_GLOW_INCLUDED_=1


feature_glow() {
	FEAT_NAME="glow"
	FEAT_LIST_SCHEMA="2_1_2@x64:binary 2_1_1@x64:binary 2_1_2@x86:binary 2_1_1@x86:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Render markdown on the CLI, with pizzazz!"
	FEAT_LINK="https://github.com/charmbracelet/glow https://charm.land/apps/"
}

feature_glow_2_1_2() {

	FEAT_VERSION="2_1_2"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/charmbracelet/glow/releases/download/v2.1.2/glow_2.1.2_Darwin_x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="glow_2.1.2_Darwin_x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/charmbracelet/glow/releases/download/v2.1.2/glow_2.1.2_Darwin_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="glow_2.1.2_Darwin_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/charmbracelet/glow/releases/download/v2.1.2/glow_2.1.2_Linux_x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="glow_2.1.2_Linux_x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
			FEAT_BINARY_URL_x86="https://github.com/charmbracelet/glow/releases/download/v2.1.2/glow_2.1.2_Linux_i386.tar.gz"
			FEAT_BINARY_URL_FILENAME_x86="glow_2.1.2_Linux_i386.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/charmbracelet/glow/releases/download/v2.1.2/glow_2.1.2_Linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="glow_2.1.2_Linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
			FEAT_BINARY_URL_x86="https://github.com/charmbracelet/glow/releases/download/v2.1.2/glow_2.1.2_Linux_arm.tar.gz"
			FEAT_BINARY_URL_FILENAME_x86="glow_2.1.2_Linux_arm.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/glow"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}

feature_glow_2_1_1() {

	FEAT_VERSION="2_1_1"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/charmbracelet/glow/releases/download/v2.1.1/glow_2.1.1_Darwin_x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="glow_2.1.1_Darwin_x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/charmbracelet/glow/releases/download/v2.1.1/glow_2.1.1_Darwin_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="glow_2.1.1_Darwin_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/charmbracelet/glow/releases/download/v2.1.1/glow_2.1.1_Linux_x86_64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="glow_2.1.1_Linux_x86_64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
			FEAT_BINARY_URL_x86="https://github.com/charmbracelet/glow/releases/download/v2.1.1/glow_2.1.1_Linux_i386.tar.gz"
			FEAT_BINARY_URL_FILENAME_x86="glow_2.1.1_Linux_i386.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/charmbracelet/glow/releases/download/v2.1.1/glow_2.1.1_Linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="glow_2.1.1_Linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
			FEAT_BINARY_URL_x86="https://github.com/charmbracelet/glow/releases/download/v2.1.1/glow_2.1.1_Linux_arm.tar.gz"
			FEAT_BINARY_URL_FILENAME_x86="glow_2.1.1_Linux_arm.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/glow"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}




feature_glow_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"
}








fi
