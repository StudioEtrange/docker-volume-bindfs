PLUGIN_NAME = studioetrange/bindfs
# docker plugin version
PLUGIN_TAG ?= 2.1
BINDFS_VERSION ?=1_13_11
DOCKER_LOGIN ?=
DOCKER_PASSWORD ?=

all: clean image rootfs create-plugin
all-nocache: clean image-nocache rootfs create-plugin

enable: 
enable-debug:

test: image run
test-nocache: image-nocache run

clean:
	@echo "### rm ./plugin"
	@rm -rf ./plugin

image:
	@echo "### docker build: build docker image"
	@docker build --build-arg BINDFS_VERSION=${BINDFS_VERSION} --build-arg PLUGIN_TAG=${PLUGIN_TAG} -t ${PLUGIN_NAME}:rootfs .

image-nocache:
	@echo "### docker build: build docker image without using cache"
	@docker build --no-cache --build-arg BINDFS_VERSION=${BINDFS_VERSION} --build-arg PLUGIN_TAG=${PLUGIN_TAG} -t ${PLUGIN_NAME}:rootfs .

run:
	@echo "### docker run: launch docker image for test"
	@docker run --rm -it --device /dev/fuse --cap-add SYS_ADMIN -v /var/lib/docker/plugins:/mnt/state -v /:/mnt/host ${PLUGIN_NAME}:rootfs sh

rootfs:
	@echo "### create rootfs directory in ./plugin/rootfs"
	@mkdir -p ./plugin/rootfs
	@docker create --name tmp ${PLUGIN_NAME}:rootfs
	@docker export tmp | tar -x -C ./plugin/rootfs
	@echo "### copy config.json to ./plugin/"
	@cp config.json ./plugin/
	@docker rm -vf tmp

create-plugin:
	@echo "### unregister and remove existing plugin ${PLUGIN_NAME}:${PLUGIN_TAG} if any"
	@docker plugin rm -f ${PLUGIN_NAME}:${PLUGIN_TAG} || true
	@docker plugin rm -f ghcr.io/${PLUGIN_NAME}:${PLUGIN_TAG} || true
	@echo "### create plugin ${PLUGIN_NAME}:${PLUGIN_TAG} from ./plugin"
	@docker plugin create ${PLUGIN_NAME}:${PLUGIN_TAG} ./plugin
	@docker plugin create ghcr.io/${PLUGIN_NAME}:${PLUGIN_TAG} ./plugin

enable:
	@echo "### enable plugin in standard mode ${PLUGIN_NAME}:${PLUGIN_TAG}"
	@docker plugin disable ${PLUGIN_NAME}:${PLUGIN_TAG} 2>/dev/null || true
	@docker plugin set studioetrange/bindfs:latest DEBUG=0
	@docker plugin enable ${PLUGIN_NAME}:${PLUGIN_TAG}

enable-debug:
	@echo "### enable plugin in DEBUG mode ${PLUGIN_NAME}:${PLUGIN_TAG}"
	@docker plugin disable ${PLUGIN_NAME}:${PLUGIN_TAG} 2>/dev/null || true
	@docker plugin set studioetrange/bindfs:latest DEBUG=1
	@docker plugin enable ${PLUGIN_NAME}:${PLUGIN_TAG}

push:
	@echo "### log into docker hub"
	@docker login -u ${DOCKER_LOGIN} -p ${DOCKER_PASSWORD}
	@echo "### push plugin ${PLUGIN_NAME}:${PLUGIN_TAG}"
	@docker plugin push ${PLUGIN_NAME}:${PLUGIN_TAG}
