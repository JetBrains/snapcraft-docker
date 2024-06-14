# Snapcraft Docker image

This repository contains sources of [`jetbrains/snapcraft`](https://hub.docker.com/r/jetbrains/snapcraft) docker image, similar to official one — [`snapcore/snapcraft`](https://hub.docker.com/r/snapcore/snapcraft).

This repository is based on https://github.com/canonical/snapcraft/ taking only history for `docker/` and `COPYING` from there.


## Why fork?
`jetbrains/snapcraft` is multi-arch (amd64 and arm64), bundles fresh snap version with `--build-for` support.

## Sources license
As in original repository — GPL 3.0, see [COPYING](COPYING).

## Usage
Same as for `snapcore/snapcraft`, e.g.:

```bash
docker run --rm \
    --volume="$PWD/snapcraft.yaml:/build/snapcraft.yaml:ro" \
    --volume="$PWD/dist:/build/dist:ro" \
    --volume="$PWD/result:/build/result" \
    --volume="$PWD/log:/root/.local/state/snapcraft/log" \
    --workdir=/build \
    jetbrains/snapcraft \
    snapcraft snap --build-for arm64 -o "result/simple.snap"
```

## Building

See original documentation in [DOCKER-README.md](DOCKER-README.md).

Use `/build.sh (multi|single) [push]` to build and optionally push image.

Use `test-snap/build.sh` to test it.