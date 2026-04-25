if [ ! "$_helm_INCLUDED_" = "1" ]; then
_helm_INCLUDED_=1


feature_helm() {
	FEAT_NAME="helm"
	FEAT_LIST_SCHEMA="4_1_4@x64:binary 3_19_0@x64:binary 3_13_3@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="The Kubernetes Package Manager. Helm is a tool for managing Charts. Charts are packages of pre-configured Kubernetes resources."
	FEAT_LINK="https://github.com/helm/helm https://helm.sh/"
}

feature_helm_4_1_4() {
	FEAT_VERSION="4_1_4"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://get.helm.sh/helm-v4.1.4-linux-amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="helm-v4.1.4-linux-amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://get.helm.sh/helm-v4.1.4-linux-arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="helm-v4.1.4-linux-arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://get.helm.sh/helm-v4.1.4-darwin-amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="helm-v4.1.4-darwin-amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://get.helm.sh/helm-v4.1.4-darwin-arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="helm-v4.1.4-darwin-arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/helm"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}

feature_helm_3_19_0() {
	FEAT_VERSION="3_19_0"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://get.helm.sh/helm-v3.19.0-linux-amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="helm-v3.19.0-linux-amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://get.helm.sh/helm-v3.19.0-linux-arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="helm-v3.19.0-linux-arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://get.helm.sh/helm-v3.19.0-darwin-amd64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="helm-v3.19.0-darwin-amd64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://get.helm.sh/helm-v3.19.0-darwin-arm64.tar.gz"
			FEAT_BINARY_URL_FILENAME_x64="helm-v3.19.0-darwin-arm64.tar.gz"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/helm"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}

}


feature_helm_3_13_3() {
	FEAT_VERSION="3_13_3"

	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://get.helm.sh/helm-v3.13.3-linux-amd64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="helm-v3.13.3-linux-amd64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"

	fi
	if [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://get.helm.sh/helm-v3.13.3-darwin-amd64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="helm-v3.13.3-darwin-amd64.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/helm"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}


feature_helm_install_binary() {

	__get_resource "${FEAT_NAME}" "${FEAT_BINARY_URL}" "${FEAT_BINARY_URL_PROTOCOL}" "${FEAT_INSTALL_ROOT}" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"

}


fi
