if [ ! "$_KIND_INCLUDED_" = "1" ]; then
_KIND_INCLUDED_=1



# kind create cluster
# kind delete cluster


# use with kubectl cli
# export KUBECONFIG=$HOME/.kube/config
# kubectl config use-context kind-kind
# kubectl run hello --image=gcr.io/google_containers/echoserver:1.4 --port=8080

# add dashboard
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
# launch proxy to access to dashboard
# kubectl proxy
# see http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

feature_kind() {
	FEAT_NAME=kind
	FEAT_LIST_SCHEMA="0_11_1@x64:binary"
	FEAT_DEFAULT_ARCH=x64
	FEAT_DEFAULT_FLAVOUR="binary"

	
	FEAT_DESC="kind is a tool for running local Kubernetes clusters using Docker container nodes. kind was primarily designed for testing Kubernetes itself, but may be used for local development or CI."
	FEAT_LINK="https://github.com/kubernetes-sigs/kind https://kind.sigs.k8s.io/"
}


feature_kind_0_11_1() {
	FEAT_VERSION="0_11_1"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/kubernetes-sigs/kind/releases/download/v0.11.1/kind-linux-amd64"
		FEAT_BINARY_URL_FILENAME_x64="kind-linux-amd64-${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/kubernetes-sigs/kind/releases/download/v0.11.1/kind-darwin-amd64"
		FEAT_BINARY_URL_FILENAME_x64="kind-darwin-amd64-${FEAT_VERSION}"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi


	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/kind"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}"

}


feature_kind_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"

	
	if [ -f "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" ]; then
		mv "${FEAT_INSTALL_ROOT}/${FEAT_BINARY_URL_FILENAME}" "${FEAT_INSTALL_ROOT}/kind"
		chmod +x "${FEAT_INSTALL_ROOT}/kind"
	fi
}



fi
