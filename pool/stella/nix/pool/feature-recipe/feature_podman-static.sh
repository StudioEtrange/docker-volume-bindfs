if [ ! "$_PODMAN_STATIC_INCLUDED_" = "1" ]; then
_PODMAN_STATIC_INCLUDED_=1


# setup podman as rootless : https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md

feature_podman-static() {
	FEAT_NAME="podman-static"
	FEAT_LIST_SCHEMA="5_8_1@x64:binary 5_6_2@x64:binary"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Statically linked podman binary"
	FEAT_LINK="https://github.com/mgoltzsche/podman-static"
}


feature_podman-static_5_8_1() {
	FEAT_VERSION="5_8_1"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mgoltzsche/podman-static/releases/download/v5.8.1/podman-linux-amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="podman-linux-amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mgoltzsche/podman-static/releases/download/v5.8.1/podman-linux-arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="podman-linux-arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/usr/local/bin/podman"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/usr/local/bin:${FEAT_INSTALL_ROOT}/usr/local/lib/podman:${FEAT_INSTALL_ROOT}/usr/local/libexec/podman"
}

feature_podman-static_5_6_2() {
	FEAT_VERSION="5_6_2"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mgoltzsche/podman-static/releases/download/v5.6.2/podman-linux-amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="podman-linux-amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/mgoltzsche/podman-static/releases/download/v5.6.2/podman-linux-arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="podman-linux-arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/usr/local/bin/podman"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/usr/local/bin:${FEAT_INSTALL_ROOT}/usr/local/lib/podman:${FEAT_INSTALL_ROOT}/usr/local/libexec/podman"
}


feature_podman-static_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"
}


fi
