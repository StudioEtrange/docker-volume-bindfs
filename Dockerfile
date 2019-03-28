FROM golang:1.9-stretch as builder
COPY . /go/src/github.com/studioetrange/docker-volume-bindfs
WORKDIR /go/src/github.com/studioetrange/docker-volume-bindfs
RUN set -ex && go install --ldflags '-extldflags "-static"'
CMD ["/go/bin/docker-volume-bindfs"]

FROM debian
RUN apt-get update && apt-get install curl git libfuse-dev -y
RUN mkdir -p /run/docker/plugins /mnt/state /mnt/volumes /mnt/host/ /work
# install bindfs
ARG BINDFS_VERSION 1_13_10
RUN cd /work \
    && git clone https://github.com/StudioEtrange/stella \
    && cd /work/stella \
    && git checkout d8a8b94ebcd341779e58bdc5540c54e3293281e2 \
    && /work/stella/stella.sh sys install build-chain-standard \
    && /work/stella/stella.sh feature install bindfs#${BINDFS_VERSION} \
    && BINDFS_PATH=$(STELLA_LOG_STATE=OFF /work/stella/stella.sh boot cmd local -- '$STELLA_API feature_info "bindfs" "BINDFS" && echo $BINDFS_FEAT_INSTALL_ROOT')
    && cp ${BINDFS_PATH}/bin/bindfs /bin/ \
    && rm -Rf /work

COPY --from=builder /go/bin/docker-volume-bindfs .
CMD ["docker-volume-bindfs"]
