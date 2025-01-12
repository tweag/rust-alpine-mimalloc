#!/bin/sh

set -eu

TARGET=$(rustc -vV | sed -n "s|host: ||p")

exec cargo install --root "$PWD" --target "$TARGET" names
