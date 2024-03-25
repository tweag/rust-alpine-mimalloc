#!/bin/sh

set -eu

TARGET=$(rustc -vV | sed -n "s|host: ||p")

RUSTFLAGS="-C target-feature=+crt-static" exec cargo install --root "$PWD" --target "$TARGET" names
