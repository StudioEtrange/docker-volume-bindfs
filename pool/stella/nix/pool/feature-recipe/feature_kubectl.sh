if [ ! "$_kubectl_INCLUDED_" = "1" ]; then
_kubectl_INCLUDED_=1

# include kubectl
# last stable version : https://dl.k8s.io/release/stable.txt
# versions : https://kubernetes.io/releases/

feature_kubectl() {
	FEAT_NAME="kubectl"
	FEAT_LIST_SCHEMA="1_24_1:binary 1_23_7:binary 1_22_10:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC=""
	FEAT_LINK=""
}


feature_kubectl_1_24_1() {
	FEAT_VERSION="1_24_1"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL="https://storage.googleapis.com/kubernetes-release/release/v1.24.1/bin/linux/amd64/kubectl"
		FEAT_BINARY_URL_FILENAME="kubectl-linux-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL="HTTP"

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://storage.googleapis.com/kubernetes-release/release/v1.24.1/bin/darwin/amd64/kubectl"
		FEAT_BINARY_URL_FILENAME="kubectl-darwin-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL="HTTP"
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/kubectl"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/"

}


feature_kubectl_1_23_7() {
	FEAT_VERSION="1_23_7"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL="https://storage.googleapis.com/kubernetes-release/release/v1.23.7/bin/linux/amd64/kubectl"
		FEAT_BINARY_URL_FILENAME="kubectl-linux-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL="HTTP"

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://storage.googleapis.com/kubernetes-release/release/v1.23.7/bin/darwin/amd64/kubectl"
		FEAT_BINARY_URL_FILENAME="kubectl-darwin-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL="HTTP"
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/kubectl"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/"

}




feature_kubectl_1_22_10() {
	FEAT_VERSION="1_22_10"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL="https://storage.googleapis.com/kubernetes-release/release/v1.22.10/bin/linux/amd64/kubectl"
		FEAT_BINARY_URL_FILENAME="kubectl-linux-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL="HTTP"

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://storage.googleapis.com/kubernetes-release/release/v1.22.10/bin/darwin/amd64/kubectl"
		FEAT_BINARY_URL_FILENAME="kubectl-darwin-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL="HTTP"
	fi


	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/kubectl"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/"

}



feature_kubectl_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "FORCE_NAME $FEAT_BINARY_URL_FILENAME"
	
	mv "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" "${FEAT_INSTALL_ROOT}/kubectl"
	chmod +x "${FEAT_INSTALL_ROOT}/kubectl"
}


fi
