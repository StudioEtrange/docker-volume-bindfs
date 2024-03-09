FROM golang:1.22.1-bullseye as builder
#FROM golang:1.21.6-bullseye as builder
#FROM golang:1.20.1-bullseye as builder
#FROM golang:1.14.12-stretch as builder
#FROM golang:1.9-stretch as builder
COPY . /go/src/github.com/StudioEtrange/docker-volume-bindfs
WORKDIR /go/src/github.com/StudioEtrange/docker-volume-bindfs
ARG PLUGIN_TAG

RUN set -ex \
    && git config --global --add safe.directory /go/src/github.com/StudioEtrange/docker-volume-bindfs \
    && go install --ldflags '-extldflags "-static"' --ldflags "-X github.com/StudioEtrange/docker-volume-bindfs/version.Version=$PLUGIN_TAG"
CMD ["/go/bin/docker-volume-bindfs"]


#FROM debian:jessie
FROM debian:bullseye
RUN apt-get update && apt-get install sudo wget git libfuse-dev -y
RUN mkdir -p /run/docker/plugins /mnt/state /mnt/volumes /mnt/host /work
# install bindfs
ARG BINDFS_VERSION


RUN wget -O /dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 \
     && chmod +x /dumb-init

RUN cd /work \
    && git clone https://github.com/StudioEtrange/stella \
    && cd /work/stella \
    && git checkout 0b7f32a1a1d36248333f5a9ac6b9aefdaa9faffc \
    && /work/stella/stella.sh sys install build-chain-standard \
    && /work/stella/stella.sh feature install bindfs#${BINDFS_VERSION} \
    && export BINDFS_PATH=$(STELLA_LOG_STATE=OFF /work/stella/stella.sh boot cmd local -- '$STELLA_API feature_info "bindfs" "BINDFS" && echo $BINDFS_FEAT_INSTALL_ROOT') \
    && echo copy bindfs from $BINDFS_PATH \
    && cp $BINDFS_PATH/bin/bindfs /bin/ \
    && cd / \
    && rm -Rf /work

COPY --from=builder /go/bin/docker-volume-bindfs .
CMD ["docker-volume-bindfs"]
