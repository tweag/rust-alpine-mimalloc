FROM alpine:latest

COPY .cargo /root/.cargo

COPY build.sh mimalloc.diff /tmp

RUN /tmp/build.sh

ENV LD_PRELOAD=/usr/lib/libmimalloc.so
