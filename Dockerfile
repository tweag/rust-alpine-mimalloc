FROM ghcr.io/rust-lang/rust:alpine

COPY .cargo/config.toml /usr/local/cargo/config.toml

COPY build.sh mimalloc.diff /tmp

RUN /tmp/build.sh

ENV LD_PRELOAD=/usr/lib/libmimalloc.so
