FROM rust:alpine

COPY build.sh mimalloc.diff /tmp

RUN /tmp/build.sh
