FROM golang:1.9-stretch as builder
COPY . /go/src/github.com/studioetrange/docker-volume-bindfs
WORKDIR /go/src/github.com/studioetrange/docker-volume-bindfs
RUN set -ex && go install --ldflags '-extldflags "-static"'
CMD ["/go/bin/docker-volume-bindfs"]

FROM debian
RUN apt-get update && apt-get install sudo curl git libfuse-dev -y
RUN mkdir -p /run/docker/plugins /mnt/state /mnt/volumes /mnt/host/ /work
# install bindfs
ARG BINDFS_VERSION
RUN cd /work \
    && git clone https://github.com/StudioEtrange/stella \
    && cd /work/stella \
    && git checkout bbf9dd926fd8025fc9aacf91bfbeae543e4b228f \
    && /work/stella/stella.sh sys install build-chain-standard \
    && /work/stella/stella.sh feature install bindfs#${BINDFS_VERSION} \
    && export BINDFS_PATH=$(STELLA_LOG_STATE=OFF /work/stella/stella.sh boot cmd local -- '$STELLA_API feature_info "bindfs" "BINDFS" && echo $BINDFS_FEAT_INSTALL_ROOT') \
    && echo copy bindfs from $BINDFS_PATH \
    && cp $BINDFS_PATH/bin/bindfs /bin/ \
    && cd / \
    && rm -Rf /work

COPY --from=builder /go/bin/docker-volume-bindfs .
CMD ["docker-volume-bindfs"]
