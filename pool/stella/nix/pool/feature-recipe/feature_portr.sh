if [ ! "$_PORTR_INCLUDED_" = "1" ]; then
_PORTR_INCLUDED_=1


feature_portr() {
	FEAT_NAME="portr"
	FEAT_LIST_SCHEMA="1_0_8@x64:binary 0_0_43@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Expose local HTTP, TCP, or WebSocket connections to the public internet with a self-hosted tunnel solution designed for teams"
	FEAT_LINK="https://github.com/amalshaji/portr https://portr.dev/ https://korben.info/portr-tunneliser-facilement-connexions-http-tcp.html"
}

feature_portr_1_0_8() {

	FEAT_VERSION="1_0_8"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/amalshaji/portr/releases/download/1.0.8-beta/portr_1.0.8-beta_Darwin_x86_64.zip"
			FEAT_BINARY_URL_FILENAME_x64="portr_1.0.8-beta_Darwin_x86_64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/amalshaji/portr/releases/download/1.0.8-beta/portr_1.0.8-beta_Darwin_arm64.zip"
			FEAT_BINARY_URL_FILENAME_x64="portr_1.0.8-beta_Darwin_arm64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/amalshaji/portr/releases/download/1.0.8-beta/portr_1.0.8-beta_Linux_x86_64.zip"
			FEAT_BINARY_URL_FILENAME_x64="portr_1.0.8-beta_Linux_x86_64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/amalshaji/portr/releases/download/1.0.8-beta/portr_1.0.8-beta_Linux_arm64.zip"
			FEAT_BINARY_URL_FILENAME_x64="portr_1.0.8-beta_Linux_arm64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/portr"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}

feature_portr_0_0_43() {

	FEAT_VERSION="0_0_43"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/amalshaji/portr/releases/download/0.0.43-beta/portr_0.0.43-beta_Darwin_x86_64.zip"
			FEAT_BINARY_URL_FILENAME_x64="portr_0.0.43-beta_Darwin_x86_64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/amalshaji/portr/releases/download/0.0.43-beta/portr_0.0.43-beta_Darwin_arm64.zip"
			FEAT_BINARY_URL_FILENAME_x64="portr_0.0.43-beta_Darwin_arm64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/amalshaji/portr/releases/download/0.0.43-beta/portr_0.0.43-beta_Linux_x86_64.zip"
			FEAT_BINARY_URL_FILENAME_x64="portr_0.0.43-beta_Linux_x86_64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/amalshaji/portr/releases/download/0.0.43-beta/portr_0.0.43-beta_Linux_arm64.zip"
			FEAT_BINARY_URL_FILENAME_x64="portr_0.0.43-beta_Linux_arm64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/portr"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}




feature_portr_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE"
}








fi
