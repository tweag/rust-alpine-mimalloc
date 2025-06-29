#!/bin/sh

set -eu

MIMALLOC_VERSION=3.1.5

cd /tmp

apk upgrade --no-cache

apk add --no-cache \
  alpine-sdk \
  cargo \
  clang \
  cmake \
  curl \
  mold \
  ninja-is-really-ninja

find /usr -type f -executable -name "ld" -exec sh -c 'ln -sf /usr/bin/ld.mold {}' \;

curl -f -L --retry 5 https://github.com/microsoft/mimalloc/archive/refs/tags/v$MIMALLOC_VERSION.tar.gz | tar xz

cd mimalloc-$MIMALLOC_VERSION

patch -p1 < /tmp/mimalloc.diff

cmake \
  -Bout \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DMI_BUILD_OBJECT=OFF \
  -DMI_BUILD_TESTS=OFF \
  -DMI_LIBC_MUSL=ON \
  -DMI_SKIP_COLLECT_ON_EXIT=ON \
  -G Ninja \
  .

cmake --build out --target install -- -v

for libc_path in $(find /usr -name libc.a); do
  {
    echo "CREATE libc.a"
    echo "ADDLIB $libc_path"
    echo "DELETE aligned_alloc.lo calloc.lo donate.lo free.lo libc_calloc.lo lite_malloc.lo malloc.lo malloc_usable_size.lo memalign.lo posix_memalign.lo realloc.lo reallocarray.lo valloc.lo"
    echo "ADDLIB out/libmimalloc.a"
    echo "SAVE"
  } | ar -M
  mv libc.a $libc_path
done

rm -rf \
  /tmp/build.sh \
  /tmp/mimalloc.diff \
  /tmp/mimalloc-$MIMALLOC_VERSION
