#!/usr/bin/env bash

set -euo pipefail

workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

cd "$workdir"

git clone --depth=1 --branch=v3.3.2 https://github.com/microsoft/mimalloc.git .

git apply "$OLDPWD/mimalloc.diff"

git diff --minimal > "$OLDPWD/mimalloc.diff"
