#!/bin/bash

set -xeo pipefail

case "$(uname -p)" in
x86_64) arch=amd64;;
aarch64) arch=arm64 ;;
*) echo "Unsupported arch '$(uname -p)'" && exit 1;;
esac

echo "--- unpacking bases for snapcraft/$RISK ---"

# Grab the core snaps (which snapcraft uses as a base) from the stable channel
# and unpack them in the proper place.
BASES="core core18 core20 core22"
for base in $BASES; do
    curl -fsSL "$(curl -fsS -H "X-Ubuntu-Architecture: $arch" -H "X-Ubuntu-Series: 16" "https://api.snapcraft.io/api/v1/snaps/details/$base" | jq ".download_url" -r)" --output "$base.snap"
    mkdir -p "/snap/$base"
    unsquashfs -d "/snap/$base/current" "$base.snap"
done


echo "--- unpacking snapcraft/$RISK ---"

# Grab the snapcraft snap from the $RISK channel and unpack it in the proper
# place.
curl -fsSL "$(curl -fsS -H "X-Ubuntu-Architecture: $arch" -H "X-Ubuntu-Series: 16" "https://api.snapcraft.io/api/v1/snaps/details/snapcraft?channel=$RISK" | jq ".download_url" -r)" --output snapcraft.snap
mkdir -p /snap/snapcraft
unsquashfs -d /snap/snapcraft/current snapcraft.snap

# Create a snapcraft runner (TODO: move version detection to the core of snapcraft).
mkdir -p /snap/bin
snap_version="$(awk '/^version:/{print $2}' /snap/snapcraft/current/meta/snap.yaml | tr -d \')"
cat >/snap/bin/snapcraft <<EOF
#!/bin/sh
export SNAP_VERSION="$snap_version"
export SNAP_ARCH="$arch"
exec "\$SNAP/usr/bin/python3" "\$SNAP/bin/snapcraft" "\$@"
EOF
chmod +x /snap/bin/snapcraft
