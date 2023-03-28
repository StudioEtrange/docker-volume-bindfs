if [ ! "$_minishift_INCLUDED_" = "1" ]; then
_minishift_INCLUDED_=1

# openshift origin single-node cluster, inside a single VM on localhost
# https://github.com/jimmidyson/minishift

# example :
# minishift start --vm-driver=virtualbox
# eval $(minishift docker-env)
# minishift console
# <admin/admin>

# use with openshift origin client
# oc config set-context minishift
# oc login --username=admin --password=admin
# oc status

# oc run hello-minishift --image=gcr.io/google_containers/echoserver:1.4 --port=8080 --expose --service-overrides='{"apiVersion": "v1", "spec": {"type": "NodePort"}}'
# oc get pods


# use with docker
# docker ps




feature_minishift() {
	FEAT_NAME=minishift
	FEAT_LIST_SCHEMA="1_13_1:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}

feature_minishift_1_13_1() {
	FEAT_VERSION=1_13_1
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://github.com/minishift/minishift/releases/download/v1.13.1/minishift-1.13.1-linux-amd64.tgz
		FEAT_BINARY_URL_FILENAME=minishift-1.13.1-linux-amd64.tgz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://github.com/minishift/minishift/releases/download/v1.13.1/minishift-1.13.1-darwin-amd64.tgz
		FEAT_BINARY_URL_FILENAME=minishift-1.13.1-darwin-amd64.tgz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/minishift
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}



feature_minishift_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP"

}


fi
