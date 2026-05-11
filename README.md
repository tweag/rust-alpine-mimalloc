# `rust-alpine-mimalloc`

This Docker image builds upon the `ghcr.io/rust-lang/rust:alpine`
image and replaces the default musl malloc implementation with
[`mimalloc`](https://github.com/microsoft/mimalloc). If you build Rust
or C/C++ static executables in this image, the resulting executables
will automatically link with `mimalloc` without needing any special
build flags.

Notice: we use the official Rust toolchain from the upstream Rust
container image, not the `cargo`/`rust` packages from Alpine. The
Alpine-packaged Rust toolchain uses targets like
`x86_64-alpine-linux-musl`, which currently do not support proc-macro
crate outputs and can fail builds that depend on proc macros.

The default Rust host target is therefore the regular musl target,
such as `x86_64-unknown-linux-musl` or `aarch64-unknown-linux-musl`.
Those targets are statically linked by default, so executables
continue to link against `mimalloc` as intended. No extra `--target`
flag or `-C target-feature=+crt-static` flag is required for the
default host build; avoiding that forced rustflag also keeps
proc-macro dependencies working when Cargo is invoked without an
explicit target:

```sh
$ cargo install foo
```

Both the system musl `libc.a` and Rust's self-contained musl `libc.a`
are patched with `mimalloc`.

Supported & tested archs: `amd64` and `arm64/v8`.

For more details, see this [blog
post](https://www.tweag.io/blog/2023-08-10-rust-static-link-with-mimalloc).
