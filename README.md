# `rust-alpine-mimalloc`

This Docker image builds upon the official `rust:alpine` image and
replaces the default musl malloc implementation with
[`mimalloc`](https://github.com/microsoft/mimalloc). If you build Rust
or C/C++ static executables in this image, the resulting executables
will automatically link with `mimalloc` without needing any special
build flags.

Supported & tested archs: `amd64` and `arm64v8`.

For more details, see this [blog
post](https://www.tweag.io/blog/2023-08-10-rust-static-link-with-mimalloc).
