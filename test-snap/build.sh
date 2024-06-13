#!/bin/bash
set -euxo pipefail

cd "$(dirname "$0")"

mkdir -p result
mkdir -p log

for arch in "amd64" "arm64"; do
  docker run --rm \
    --volume="$PWD/snapcraft.yaml:/build/snapcraft.yaml:ro" \
    --volume="$PWD/result:/build/result" \
    --volume="$PWD/dist.all:/build/dist.all:ro" \
    --volume="$PWD/log:/root/.local/state/snapcraft/log" \
    --workdir=/build \
    "$1" \
    snapcraft snap "--build-for=$arch" -o "result/simple_$arch.snap"

    rm -rf "result/unpacked/$arch"
    mkdir -p "result/unpacked/$arch"
    unsquashfs -d "result/unpacked/$arch" "result/simple_$arch.snap"
done

echo "========"
echo "Difference between two versions:"
diff -r "result/unpacked/arm64" "result/unpacked/amd64"
