if [ ! "$_minikube_INCLUDED_" = "1" ]; then
_minikube_INCLUDED_=1

# kubernetes single-node cluster, inside a single VM on localhost
# https://github.com/kubernetes/minikube
# https://medium.com/@claudiopro/getting-started-with-kubernetes-via-minikube-ada8c7a29620#.3hu5p2m7j

# example :
# minikube start --vm-driver=virtualbox
# minikube dashboard

# use kubectl from minikube
#	minikube kubectl -- help

# use with an already installed kubectl
# export KUBECONFIG=$HOME/.kube/config
# kubectl config use-context minikube
# kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080

# use docker driver instead of VM (on linux) https://minikube.sigs.k8s.io/docs/drivers/docker/
# Start a cluster using the docker driver:
#		minikube start --driver=docker
# To make docker the default driver:
#		minikube config set driver docker

# interact through docker client
# 	eval $(minikube docker-env)
# 	docker ps

# log into minikube VM
# minikube ssh

feature_minikube() {
	FEAT_NAME="minikube"
	FEAT_LIST_SCHEMA="1_25_2:binary 1_23_2:binary 0_25_0:binary 0_11_0:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="minikube implements a local Kubernetes cluster on macOS, Linux, and Windows. All you need is Docker (or similarly compatible) container or a Virtual Machine environment, and Kubernetes is a single command away : minikube start"
	FEAT_LINK="https://github.com/kubernetes/minikube https://minikube.sigs.k8s.io/"
}


feature_minikube_1_25_2() {
	FEAT_VERSION="1_25_2"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL="https://github.com/kubernetes/minikube/releases/download/v1.25.2/minikube-linux-amd64"
		FEAT_BINARY_URL_FILENAME="minikube-${FEAT_VERSION}-linux-amd64"
		FEAT_BINARY_URL_PROTOCOL="HTTP"

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://github.com/kubernetes/minikube/releases/download/v1.25.2/minikube-darwin-amd64"
		FEAT_BINARY_URL_FILENAME="minikube-${FEAT_VERSION}-darwin-amd64"
		FEAT_BINARY_URL_PROTOCOL="HTTP"
	fi


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/minikube"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_minikube_1_23_2() {
	FEAT_VERSION="1_23_2"


	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL="https://github.com/kubernetes/minikube/releases/download/v1.23.2/minikube-linux-amd64"
		FEAT_BINARY_URL_FILENAME="minikube-${FEAT_VERSION}-linux-amd64"
		FEAT_BINARY_URL_PROTOCOL="HTTP"

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://github.com/kubernetes/minikube/releases/download/v1.23.2/minikube-darwin-amd64"
		FEAT_BINARY_URL_FILENAME="minikube-${FEAT_VERSION}-darwin-amd64"
		FEAT_BINARY_URL_PROTOCOL="HTTP"
	fi



	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/minikube"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_minikube_0_25_0() {
	FEAT_VERSION="0_25_0"


	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL="https://github.com/kubernetes/minikube/releases/download/v0.25.0/minikube-linux-amd64"
		FEAT_BINARY_URL_FILENAME="minikube-0_25_0-linux-amd64"
		FEAT_BINARY_URL_PROTOCOL="HTTP"

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://github.com/kubernetes/minikube/releases/download/v0.25.0/minikube-darwin-amd64"
		FEAT_BINARY_URL_FILENAME="minikube-0_25_0-darwin-amd64"
		FEAT_BINARY_URL_PROTOCOL="HTTP"
	fi



	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/minikube"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}




# with kubernetes v1.4.0
feature_minikube_0_11_0() {
	FEAT_VERSION="0_11_0"


	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL="https://github.com/kubernetes/minikube/releases/download/v0.11.0/minikube-linux-amd64"
		FEAT_BINARY_URL_FILENAME="minikube-0_11_0-linux-amd64"
		FEAT_BINARY_URL_PROTOCOL=HTTP

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL="https://github.com/kubernetes/minikube/releases/download/v0.11.0/minikube-darwin-amd64"
		FEAT_BINARY_URL_FILENAME="minikube-0_11_0-darwin-amd64"
		FEAT_BINARY_URL_PROTOCOL=HTTP
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/minikube"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}



feature_minikube_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "FORCE_NAME $FEAT_BINARY_URL_FILENAME"

	mv "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME" "$FEAT_INSTALL_ROOT/minikube"
	chmod +x "$FEAT_INSTALL_ROOT/minikube"

}


fi
