if [ ! "$_CARBONYL_INCLUDED_" = "1" ]; then
_CARBONYL_INCLUDED_=1

# runtime dependencies for 0.0.3 https://github.com/fathyb/carbonyl/releases/tag/v0.0.3
# libnss3: SSL library needed for root SSL certificates
# libexpat1: XML library, will be removed in the future
# libasound2: ALSA library for audio playback https://formulae.brew.sh/formula/libsoundio
# libfontconfig1: we need the configuration this package generates

# forks
# fork                          ahead  behind  stars  last_commit_date      pushed_at             url
# Qubitdyne/carbonyl            41     0       6      2025-09-30T07:06:30Z  2025-09-30T08:30:55Z  https://github.com/Qubitdyne/carbonyl
#	Support for Sixel rendering engine
# JeffCarpenter/carbonyl        40     0       0      2025-09-30T07:06:08Z  2025-11-11T07:05:57Z  https://github.com/JeffCarpenter/carbonyl
# 	Merge a lot of commits of Qubitdyne/carbonyl 
# gyoz-ai/terminal-chromium     29     0       2      2026-03-29T11:19:48Z  2026-03-29T11:19:50Z  https://github.com/gyoz-ai/terminal-chromium
#	Fixes for CI
# jmagly/carbonyl               17     0       1      2026-04-06T05:44:33Z  2026-04-06T05:49:36Z  https://github.com/jmagly/carbonyl
#	self declared as active fork - include chromium M120
# arielm-cloudbuzz/carbonyl     14     0       0      2023-04-16T14:21:16Z  2023-04-16T14:21:16Z  https://github.com/arielm-cloudbuzz/carbonyl
#	work on docker image for CI
# AlexanderMaxRanabel/carbonyl  10     0       2      2024-07-01T14:31:48Z  2024-07-01T14:31:48Z  https://github.com/AlexanderMaxRanabel/carbonyl
#	only add documentation
# diyism/carbonyl               10     45      0      2025-12-16T14:36:04Z  2025-12-16T14:36:05Z  https://github.com/diyism/carbonyl
#	only add documentation
# aaronbanse/carbonyl-ftty      7      0       1      2026-02-09T00:28:14Z  2026-02-09T00:28:22Z  https://github.com/aaronbanse/carbonyl-ftty
#	add new dependency fidelity - https://github.com/aaronbanse/fidelitty - library for high performance rendering in the terminal using unicode characters and escape sequences



feature_carbonyl() {
	FEAT_NAME="carbonyl"
	FEAT_LIST_SCHEMA="0_0_3@x64:binary"
	FEAT_DEFAULT_FLAVOUR="binary"
	FEAT_DESC="Chromium based browser built to run in a terminal"
	FEAT_LINK="https://github.com/fathyb/carbonyl"
}

feature_carbonyl_0_0_3() {
	FEAT_VERSION="0_0_3"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/fathyb/carbonyl/releases/download/v0.0.3/carbonyl.macos-amd64.zip"
			FEAT_BINARY_URL_FILENAME_x64="carbonyl-macos-amd64-${FEAT_VERSION}.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/fathyb/carbonyl/releases/download/v0.0.3/carbonyl.macos-arm64.zip"
			FEAT_BINARY_URL_FILENAME_x64="carbonyl-macos-arm64-${FEAT_VERSION}.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/fathyb/carbonyl/releases/download/v0.0.3/carbonyl.linux-amd64.zip"
			FEAT_BINARY_URL_FILENAME_x64="carbonyl-linux-amd64-${FEAT_VERSION}.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/fathyb/carbonyl/releases/download/v0.0.3/carbonyl.linux-arm64.zip"
			FEAT_BINARY_URL_FILENAME_x64="carbonyl-linux-arm64-${FEAT_VERSION}.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/carbonyl"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}

feature_carbonyl_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"
	
	if [ -f "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" ]; then
		mv "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" "${FEAT_INSTALL_ROOT}/carbonyl"
		chmod +x "${FEAT_INSTALL_ROOT}/carbonyl"
	fi
}

fi
