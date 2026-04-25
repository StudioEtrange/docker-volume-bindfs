if [ ! "$_ttyd_INCLUDED_" = "1" ]; then
_ttyd_INCLUDED_=1

# macports : https://ports.macports.org/port/ttyd/details/ 

feature_ttyd() {
	FEAT_NAME="ttyd"
	FEAT_LIST_SCHEMA="latest_homebrew:binary 1_7_7@x64:binary 1_7_7@x86:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Share your terminal over the web"
	FEAT_LINK="https://tsl0922.github.io/ttyd https://github.com/tsl0922/ttyd https://formulae.brew.sh/formula/ttyd"
}


feature_ttyd_latest_homebrew() {
	FEAT_VERSION="latest_homebrew"

	FEAT_BINARY_URL="ttyd"
	FEAT_BINARY_URL_PROTOCOL="HOMEBREW_BOTTLE"

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/bin/ttyd"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/bin"
}

feature_ttyd_1_7_7() {
	FEAT_VERSION="1_7_7"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x86="https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.i686"
			FEAT_BINARY_URL_FILENAME_x86="ttyd.i686_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
			FEAT_BINARY_URL_x64="https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64"
			FEAT_BINARY_URL_FILENAME_x64="ttyd.x86_64_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x86="https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.arm"
			FEAT_BINARY_URL_FILENAME_x86="ttyd.arm_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
			FEAT_BINARY_URL_x64="https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.aarch64"
			FEAT_BINARY_URL_FILENAME_x64="ttyd.aarch64_${FEAT_VERSION}"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/ttyd"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"
}



feature_ttyd_install_binary() {

	case $FEAT_BINARY_URL_PROTOCOL in
		HOMEBREW_BOTTLE)
			__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT"
			;;
		
		*)
			__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"
			mv "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" "${FEAT_INSTALL_ROOT}/ttyd"
			chmod +x "${FEAT_INSTALL_ROOT}/ttyd"
			;;
	esac
	
	

}


fi
