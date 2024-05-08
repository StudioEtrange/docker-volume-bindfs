PLUGIN_NAME = studioetrange/bindfs
# plugin version
PLUGIN_TAG ?= latest
BINDFS_VERSION ?=1_17_6
DOCKER_LOGIN ?=
DOCKER_PASSWORD ?=

# DOC : docker multiplatform : https://gist.github.com/StudioEtrange/ab9b118b778fac8e815c872826ed2cd8
# NOTE : we cannot use docker buildx to build simultaneous arch because building a docker plugin is not possible with docker buildx

ifdef PLATFORM
	ifeq (${PLATFORM},amd64)
		PLATFORM_FLAVOR = ${PLATFORM}
		PLATFORM_DOCKER_OPTION = --platform linux/${PLATFORM}
		PLATFORM_TAG = -${PLATFORM}
	else ifeq (${PLATFORM},arm64)
		PLATFORM_FLAVOR = ${PLATFORM}
		PLATFORM_DOCKER_OPTION = --platform linux/${PLATFORM}
		PLATFORM_TAG = -${PLATFORM}
	else
$(error "PLATFORM authorized values are amd64 or arm64") 
	endif
endif


all: clean image rootfs create-plugin
all-nocache: clean image-nocache rootfs create-plugin


test: image run
test-nocache: image-nocache run

clean:
	@echo "### rm ./plugin"
	@rm -rf ./plugin

image:
	@echo "### docker build: build ${PLATFORM_FLAVOR} docker image"
	@docker build ${PLATFORM_DOCKER_OPTION} --build-arg BINDFS_VERSION=${BINDFS_VERSION} --build-arg PLUGIN_TAG=${PLUGIN_TAG}${PLATFORM_TAG} -t ${PLUGIN_NAME}:rootfs${PLATFORM_TAG} .

image-nocache:
	@echo "### docker build: build ${PLATFORM_FLAVOR} docker image without using cache"
	@docker build ${PLATFORM_DOCKER_OPTION} --no-cache --build-arg BINDFS_VERSION=${BINDFS_VERSION} --build-arg PLUGIN_TAG=${PLUGIN_TAG}${PLATFORM_TAG} -t ${PLUGIN_NAME}:rootfs${PLATFORM_TAG} .

run:
	@echo "### docker run: launch ${PLATFORM_FLAVOR} docker image for test"
	@docker run ${PLATFORM_DOCKER_OPTION} --rm -it --device /dev/fuse --cap-add SYS_ADMIN -v /var/lib/docker/plugins:/mnt/state -v /:/mnt/host ${PLUGIN_NAME}:rootfs${PLATFORM_TAG} sh

rootfs:
	@echo "### create rootfs directory in ./plugin/rootfs"
	@rm -Rf ./plugin
	@mkdir -p ./plugin/rootfs
	@docker create --name tmp ${PLUGIN_NAME}:rootfs${PLATFORM_TAG}
	@docker export tmp | tar -x -C ./plugin/rootfs
	@echo "### copy config.json to ./plugin/"
	@cp config.json ./plugin/
	@docker rm -vf tmp

create-plugin:
	@echo "### unregister and remove existing plugin ${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG} if any"
	@docker plugin rm -f ${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG} || true
	@echo "### create plugin ${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG} from ./plugin"
	@docker plugin create ${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG} ./plugin

# used only from github CI
create-plugin-ghcr:
	@echo "### unregister and remove existing plugin ghcr.io/${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG} if any"
	@docker plugin rm -f ghcr.io/${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG} || true
	@echo "### copy rootfs from ./plugin to ./plugin-copy"
	@rm -Rf ./plugin-copy
	@cp -R ./plugin plugin-copy
	@echo "### create plugin ghcr.io/${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG} from ./plugin-copy"
	@docker plugin create ghcr.io/${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG} ./plugin-copy
	@rm -Rf ./plugin-copy

enable:
	@echo "### enable plugin in standard mode ${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG}"
	@docker plugin disable ${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG} 2>/dev/null || true
	@docker plugin set studioetrange/bindfs:latest DEBUG=0
	@docker plugin enable ${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG}

enable-debug:
	@echo "### enable plugin in DEBUG mode ${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG}"
	@docker plugin disable ${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG} 2>/dev/null || true
	@docker plugin set studioetrange/bindfs:latest DEBUG=1
	@docker plugin enable ${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG}

# push to docker hub
push:
	@echo "### log into docker hub"
	@docker login -u ${DOCKER_LOGIN} -p ${DOCKER_PASSWORD}
	@echo "### push plugin ${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG}"
	@docker plugin push ${PLUGIN_NAME}:${PLUGIN_TAG}${PLATFORM_TAG}
