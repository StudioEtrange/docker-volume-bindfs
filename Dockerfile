FROM golang:1.22.1-bullseye as gobuilder
# https://docs.docker.com/reference/dockerfile/#automatic-platform-args-in-the-global-scope
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG PLUGIN_TAG

RUN echo "Hello. I'm building the docker plugin go source code (target platform : $TARGETPLATFORM -- current build platform : $BUILDPLATFORM)"

COPY . /go/src/github.com/StudioEtrange/docker-volume-bindfs
WORKDIR /go/src/github.com/StudioEtrange/docker-volume-bindfs

# NOTE on cross compilation for arm 32 bits using GOARM env var : https://go.dev/wiki/GoArm
RUN set -ex \
    && git config --global --add safe.directory /go/src/github.com/StudioEtrange/docker-volume-bindfs \
    && GOOS=$TARGETOS GOARCH=$TARGETARCH go install --ldflags '-extldflags "-static"' --ldflags "-X github.com/StudioEtrange/docker-volume-bindfs/version.Version=$PLUGIN_TAG"
CMD ["/go/bin/docker-volume-bindfs"]




FROM debian:bullseye
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETARCH
ARG BINDFS_VERSION

RUN echo "Hello. I'm packaging all the docker plugin stuff (go docker plugin, bindfs utility, config,...) (target platform : $TARGETPLATFORM -- current build platform : $BUILDPLATFORM)"

RUN apt-get update && apt-get install sudo wget git libfuse-dev -y \
    && mkdir -p /run/docker/plugins /mnt/state /mnt/volumes /mnt/host /work


RUN [ "${TARGETARCH}" = "arm64" ] && DUMB_INIT_ARCH="aarch64" || DUMB_INIT_ARCH="x86_64" \
    && wget -O /dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_${DUMB_INIT_ARCH} \
    && chmod +x /dumb-init

RUN cd /work \
    && git clone https://github.com/StudioEtrange/stella \
    && cd /work/stella \
    && git checkout 5d876ca717efd5503e43b7738112cbfa4358561c \
    && /work/stella/stella.sh sys install build-chain-standard \
    && /work/stella/stella.sh feature install bindfs#${BINDFS_VERSION} \
    && export BINDFS_PATH=$(STELLA_LOG_STATE=OFF /work/stella/stella.sh boot cmd local -- '$STELLA_API feature_info "bindfs" "BINDFS" && echo $BINDFS_FEAT_INSTALL_ROOT') \
    && echo copy bindfs from $BINDFS_PATH \
    && cp $BINDFS_PATH/bin/bindfs /bin/ \
    && cd / \
    && rm -Rf /work

COPY --from=gobuilder /go/bin/docker-volume-bindfs .
CMD ["docker-volume-bindfs"]
