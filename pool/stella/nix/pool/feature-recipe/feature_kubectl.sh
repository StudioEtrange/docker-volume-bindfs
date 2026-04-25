if [ ! "$_kubectl_INCLUDED_" = "1" ]; then
_kubectl_INCLUDED_=1

# include kubectl
# last stable version : https://dl.k8s.io/release/stable.txt
# versions : https://kubernetes.io/releases/
#			 https://kubernetes.io/releases/download/#binaries

feature_kubectl() {
	FEAT_NAME="kubectl"
	FEAT_LIST_SCHEMA="1_29_0:binary 1_24_1:binary 1_23_7:binary 1_22_10:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters."
	FEAT_LINK="https://kubernetes.io/releases/download/#kubectl"
}





feature_kubectl_1_29_0() {
	FEAT_VERSION="1_29_0"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL="https://dl.k8s.io/v1.29.0/bin/linux/amd64/kubectl"
		FEAT_BINARY_URL_FILENAME="kubectl-linux-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL="HTTP"

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://dl.k8s.io/v1.29.0/bin/darwin/amd64/kubectl"
		FEAT_BINARY_URL_FILENAME="kubectl-darwin-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL="HTTP"
	fi

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/kubectl"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/"

}


feature_kubectl_1_24_1() {
	FEAT_VERSION="1_24_1"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL="https://dl.k8s.io/v1.24.1/bin/linux/amd64/kubectl"
		FEAT_BINARY_URL_FILENAME="kubectl-linux-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL="HTTP"

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://dl.k8s.io/v1.24.1/bin/darwin/amd64/kubectl"
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
