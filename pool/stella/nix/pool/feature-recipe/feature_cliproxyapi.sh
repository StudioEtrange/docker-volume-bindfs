
if [ ! "$_CLIPROXYAPI_INCLUDED_" = "1" ]; then
_CLIPROXYAPI_INCLUDED_=1

# Installer project : https://github.com/brokechubb/cliproxyapi-installer

feature_cliproxyapi() {
	FEAT_NAME="cliproxyapi"
	FEAT_LIST_SCHEMA="6_9_29@x64:binary 6_8_39@x64:binary 6_8_24@x64:binary 6_8_8@x64:binary 6_7_53@x64:binary 6_7_41@x64:binary"

	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Wrap Gemini CLI, Antigravity, ChatGPT Codex, Claude Code, Qwen Code, iFlow as an OpenAI/Gemini/Claude/Codex compatible API service"
	FEAT_LINK="https://github.com/router-for-me/CLIProxyAPI https://help.router-for.me/"
}



feature_cliproxyapi_6_9_29() {
	FEAT_VERSION="6_9_29"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.9.29/CLIProxyAPI_6.9.29_darwin_amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.9.29_darwin_amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.9.29/CLIProxyAPI_6.9.29_darwin_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.9.29_darwin_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.9.29/CLIProxyAPI_6.9.29_linux_amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.9.29_linux_amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.9.29/CLIProxyAPI_6.9.29_linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.9.29_linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/cli-proxy-api"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_cliproxyapi_6_8_39() {
	FEAT_VERSION="6_8_39"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.8.39/CLIProxyAPI_6.8.39_darwin_amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.8.39_darwin_amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.8.39/CLIProxyAPI_6.8.39_darwin_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.8.39_darwin_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.8.39/CLIProxyAPI_6.8.39_linux_amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.8.39_linux_amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.8.39/CLIProxyAPI_6.8.39_linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.8.39_linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/cli-proxy-api"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_cliproxyapi_6_8_24() {
	FEAT_VERSION="6_8_24"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.8.24/CLIProxyAPI_6.8.24_darwin_amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.8.24_darwin_amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.8.24/CLIProxyAPI_6.8.24_darwin_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.8.24_darwin_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.8.24/CLIProxyAPI_6.8.24_linux_amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.8.24_linux_amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.8.24/CLIProxyAPI_6.8.24_linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.8.24_linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/cli-proxy-api"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_cliproxyapi_6_8_8() {
	FEAT_VERSION="6_8_8"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.8.8/CLIProxyAPI_6.8.8_darwin_amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.8.8_darwin_amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.8.8/CLIProxyAPI_6.8.8_darwin_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.8.8_darwin_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.8.8/CLIProxyAPI_6.8.8_linux_amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.8.8_linux_amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.8.8/CLIProxyAPI_6.8.8_linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.8.8_linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/cli-proxy-api"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}



feature_cliproxyapi_6_7_53() {
	FEAT_VERSION="6_7_53"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.7.53/CLIProxyAPI_6.7.53_darwin_amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.7.53_darwin_amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.7.53/CLIProxyAPI_6.7.53_darwin_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.7.53_darwin_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.7.53/CLIProxyAPI_6.7.53_linux_amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.7.53_linux_amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.7.53/CLIProxyAPI_6.7.53_linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.7.53_linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/cli-proxy-api"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_cliproxyapi_6_7_41() {
	FEAT_VERSION="6_7_41"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.7.41/CLIProxyAPI_6.7.41_darwin_amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.7.41_darwin_amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.7.41/CLIProxyAPI_6.7.41_darwin_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.7.41_darwin_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.7.41/CLIProxyAPI_6.7.41_linux_amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.7.41_linux_amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.7.41/CLIProxyAPI_6.7.41_linux_arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="CLIProxyAPI_6.7.41_linux_arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/cli-proxy-api"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_cliproxyapi_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE"

}




fi