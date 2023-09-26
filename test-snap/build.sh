#!/bin/bash
set -euxo pipefail

mkdir -p result
mkdir -p log

for arch in "amd64" "arm64"; do
  docker run --rm \
    --volume="$PWD/snapcraft.yaml:/build/snapcraft.yaml:ro" \
    --volume="$PWD/result:/build/result" \
    --volume="$PWD/dist.all:/build/dist.all:ro" \
    --volume="$PWD/log:/root/.local/state/snapcraft/log" \
    --workdir=/build \
    "$NAME" \
    snapcraft snap "--build-for=$arch" -o "result/simple_$arch.snap"
done
