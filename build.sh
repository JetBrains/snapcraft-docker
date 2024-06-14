#!/bin/bash
set -euo pipefail
build_type="${1:-multi}"
push="${2:-}"

TAG="jetbrains/snapcraft"

if [[ "$build_type" = "multi" ]]; then
  docker buildx create --name multiarch --driver docker-container --bootstrap --use --platform=linux/arm64,linux/amd64 || :
  args=""
  if [[ "$push" = "push" ]]; then
    args+=" --push"
  fi
  # shellcheck disable=SC2086
  docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull $args -t "$TAG" .
elif [[ "$build_type" = "single" ]]; then
  docker build --pull -t "$TAG" .
  if [[ "$push" = "push" ]]; then
      docker push "$TAG"
  fi
else
  echo "Unsupported first argument: $1"
  exit 1
fi
