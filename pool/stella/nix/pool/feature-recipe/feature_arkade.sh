if [ ! "$_ARKADE_INCLUDED_" = "1" ]; then
_ARKADE_INCLUDED_=1


feature_arkade() {
	FEAT_NAME="arkade"
	FEAT_LIST_SCHEMA="0_11_93@x64:binary 0_11_50@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="arkade provides a portable marketplace for downloading your favourite devops CLIs and installing helm charts, with a single command"
	FEAT_LINK="https://github.com/alexellis/arkade https://www.youtube.com/watch?v=8wU9s_mua8M"
}

feature_arkade_0_11_93() {

	FEAT_VERSION="0_11_93"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/alexellis/arkade/releases/download/0.11.93/arkade-darwin"
			FEAT_BINARY_URL_FILENAME_x64="arkade-darwin-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/alexellis/arkade/releases/download/0.11.93/arkade-darwin-arm64"
			FEAT_BINARY_URL_FILENAME_x64="arkade-darwin-arm64-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/alexellis/arkade/releases/download/0.11.93/arkade"
			FEAT_BINARY_URL_FILENAME_x64="arkade-linux64-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/alexellis/arkade/releases/download/0.11.93/arkade-arm64"
			FEAT_BINARY_URL_FILENAME_x64="arkade-arm64-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
			FEAT_BINARY_URL_x86="https://github.com/alexellis/arkade/releases/download/0.11.93/arkade-armhf"
			FEAT_BINARY_URL_FILENAME_x86="arkade-armhf-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		fi
	fi

	FEAT_ENV_CALLBACK="feature_arkade_env"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/arkade"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}

feature_arkade_0_11_50() {

	FEAT_VERSION="0_11_50"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/alexellis/arkade/releases/download/0.11.50/arkade-darwin"
			FEAT_BINARY_URL_FILENAME_x64="arkade-darwin-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/alexellis/arkade/releases/download/0.11.50/arkade-darwin-arm64"
			FEAT_BINARY_URL_FILENAME_x64="arkade-darwin-arm64-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/alexellis/arkade/releases/download/0.11.50/arkade"
			FEAT_BINARY_URL_FILENAME_x64="arkade-linux64-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/alexellis/arkade/releases/download/0.11.50/arkade-arm64"
			FEAT_BINARY_URL_FILENAME_x64="arkade-arm64-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
			FEAT_BINARY_URL_x86="https://github.com/alexellis/arkade/releases/download/0.11.50/arkade-armhf"
			FEAT_BINARY_URL_FILENAME_x86="arkade-armhf-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		fi
	fi

	FEAT_ENV_CALLBACK="feature_arkade_env"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/arkade"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}




feature_arkade_0_11_40() {

	FEAT_VERSION="0_11_40"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/alexellis/arkade/releases/download/0.11.40/arkade-darwin"
			FEAT_BINARY_URL_FILENAME_x64="arkade-darwin-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/alexellis/arkade/releases/download/0.11.40/arkade-darwin-arm64"
			FEAT_BINARY_URL_FILENAME_x64="arkade-darwin-arm64-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/alexellis/arkade/releases/download/0.11.40/arkade"
			FEAT_BINARY_URL_FILENAME_x64="arkade-linux64-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/alexellis/arkade/releases/download/0.11.40/arkade-arm64"
			FEAT_BINARY_URL_FILENAME_x64="arkade-arm64-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
			FEAT_BINARY_URL_x86="https://github.com/alexellis/arkade/releases/download/0.11.40/arkade-armhf"
			FEAT_BINARY_URL_FILENAME_x86="arkade-armhf-${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		fi
	fi

	FEAT_ENV_CALLBACK="feature_arkade_env"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/arkade"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}


feature_arkade_env(){
	export PATH="$HOME/.arkade/bin:${PATH}"
	echo "** $HOME/.arkade/bin is added to PATH"
}



feature_arkade_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"
	
	if [ -f "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" ]; then
		mv "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" "${FEAT_INSTALL_ROOT}/arkade"
		chmod +x "${FEAT_INSTALL_ROOT}/arkade"
	fi

}








fi
