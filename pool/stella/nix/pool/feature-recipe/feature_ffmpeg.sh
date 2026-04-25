if [ ! "$_ffmpeg_INCLUDED_" = "1" ]; then
_ffmpeg_INCLUDED_=1

# linux builds : 
#	https://github.com/yt-dlp/FFmpeg-Builds
#	https://github.com/BtbN/FFmpeg-Builds
# macos builds : 
#	https://evermeet.cx/ffmpeg/ 
#	https://www.osxexperts.net/ 
#	https://formulae.brew.sh/formula/ffmpeg
#	https://formulae.brew.sh/formula/ffmpeg-full

# BtbN/FFmpeg-Builds -------
# releases in BtbN/FFmpeg-Builds are named as follow :
# gpl -- Includes all dependencies, even those that require full GPL instead of just LGPL.
# lgpl -- Lacking libraries that are GPL-only. Most prominently libx264 and libx265.
# nonfree -- Includes fdk-aac in addition to all the dependencies of the gpl variant.
# gpl-shared -- Same as gpl, but comes with the libav* family of shared libs instead of pure static executables.
# lgpl-shared -- Same again, but with the lgpl set of dependencies.
# nonfree-shared -- Same again, but with the nonfree set of dependencies.

feature_ffmpeg() {
	FEAT_NAME="ffmpeg"
	[ "${STELLA_CURRENT_PLATFORM}" = "linux" ] && FEAT_LIST_SCHEMA="8_1_7@x64:binary 7_1_3_43@x64:binary"
	[ "${STELLA_CURRENT_PLATFORM}" = "darwin" ] && FEAT_LIST_SCHEMA="8_1@x64:binary 7_1_1@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="A complete, cross-platform solution to record, convert and stream audio and video."
	FEAT_LINK="https://ffmpeg.org/ https://github.com/ffmpeg/ffmpeg"
}


feature_ffmpeg_8_1_7() {
	FEAT_VERSION="8_1_7"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/BtbN/FFmpeg-Builds/releases/download/autobuild-2026-04-08-13-14/ffmpeg-n8.1-7-ga3475e2554-linux64-gpl-8.1.tar.xz"
			FEAT_BINARY_URL_FILENAME_x64="ffmpeg-n8.1-7-ga3475e2554-linux64-gpl-8.1.tar.xz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/BtbN/FFmpeg-Builds/releases/download/autobuild-2026-04-08-13-14/ffmpeg-n8.1-7-ga3475e2554-linuxarm64-gpl-8.1.tar.xz"
			FEAT_BINARY_URL_FILENAME_x64="ffmpeg-n8.1-7-ga3475e2554-linuxarm64-gpl-8.1.tar.xz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/bin/ffmpeg"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/bin"
}


feature_ffmpeg_8_1() {
	FEAT_VERSION="8_1"

	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://deolaha.ca/pub/ffmpeg/ffmpeg-8.1.zip"
			FEAT_BINARY_URL_FILENAME_x64="ffmpeg-8.1.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://www.osxexperts.net/ffmpeg81arm.zip"
			FEAT_BINARY_URL_FILENAME_x64="ffmpeg81arm.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/bin/ffmpeg"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/bin"
}



feature_ffmpeg_7_1_3_43() {
	FEAT_VERSION="7_1_3_43"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/BtbN/FFmpeg-Builds/releases/download/autobuild-2026-04-08-13-14/ffmpeg-n7.1.3-43-g5a1f107b4c-linux64-gpl-7.1.tar.xz"
			FEAT_BINARY_URL_FILENAME_x64="ffmpeg-n7.1.3-43-g5a1f107b4c-linux64-gpl-7.1.tar.xz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/BtbN/FFmpeg-Builds/releases/download/autobuild-2026-04-08-13-14/ffmpeg-n7.1.3-43-g5a1f107b4c-linuxarm64-gpl-7.1.tar.xz"
			FEAT_BINARY_URL_FILENAME_x64="ffmpeg-n7.1.3-43-g5a1f107b4c-linuxarm64-gpl-7.1.tar.xz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/bin/ffmpeg"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/bin"
}



feature_ffmpeg_7_1_1() {
	FEAT_VERSION="7_1_1"

	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		if [ "${STELLA_CURRENT_CPU_FAMILY}" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://deolaha.ca/pub/ffmpeg/ffmpeg-7.1.1.zip"
			FEAT_BINARY_URL_FILENAME_x64="ffmpeg-7.1.1.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/bin/ffmpeg"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/bin"
}


feature_ffmpeg_install_binary() {

	case $FEAT_BINARY_URL_PROTOCOL in
		HOMEBREW_BOTTLE)
			__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE"
			;;
		
		*)
			__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE STRIP"
			;;
	esac
	
	

}


fi
