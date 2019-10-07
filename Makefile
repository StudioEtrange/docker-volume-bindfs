PLUGIN_NAME = studioetrange/bindfs
PLUGIN_TAG ?= latest
BINDFS_VERSION ?=1_13_11
DOCKER_LOGIN ?=
DOCKER_PASSWORD ?=

all: clean rootfs create

clean:
	@echo "### rm ./plugin"
	@rm -rf ./plugin

rootfs:
	@echo "### docker build: rootfs image with docker-volume-bindfs"
	@docker build --no-cache --build-arg BINDFS_VERSION=${BINDFS_VERSION} --build-arg PLUGIN_TAG=${PLUGIN_TAG} -t ${PLUGIN_NAME}:rootfs .
	@echo "### create rootfs directory in ./plugin/rootfs"
	@mkdir -p ./plugin/rootfs
	@docker create --name tmp ${PLUGIN_NAME}:rootfs
	@docker export tmp | tar -x -C ./plugin/rootfs
	@echo "### copy config.json to ./plugin/"
	@cp config.json ./plugin/
	@docker rm -vf tmp

create:
	@echo "### remove existing plugin ${PLUGIN_NAME}:${PLUGIN_TAG} if exists"
	@docker plugin rm -f ${PLUGIN_NAME}:${PLUGIN_TAG} || true
	@echo "### create new plugin ${PLUGIN_NAME}:${PLUGIN_TAG} from ./plugin"
	@docker plugin create ${PLUGIN_NAME}:${PLUGIN_TAG} ./plugin

enable:
	@echo "### enable plugin ${PLUGIN_NAME}:${PLUGIN_TAG}"
	@docker plugin enable ${PLUGIN_NAME}:${PLUGIN_TAG}

push:
	@echo "### log into docker hub"
	@docker login -u ${DOCKER_LOGIN} -p ${DOCKER_PASSWORD}
	@echo "### push plugin ${PLUGIN_NAME}:${PLUGIN_TAG}"
	@docker plugin push ${PLUGIN_NAME}:${PLUGIN_TAG}
