#!/bin/bash
set -euo pipefail

DIST="bookworm"
ARCH="amd64"
WIN_USER="darianski"
OUT_ISO="/mnt/c/Users/${WIN_USER}/Desktop/JimmyOS-latest.iso"

MODE="fast"   # fast | purge | reconfig

for arg in "$@"; do
  case "$arg" in
    --purge) MODE="purge" ;;
    --reconfig) MODE="reconfig" ;;
    --dist=*) DIST="${arg#*=}" ;;
    --user=*) WIN_USER="${arg#*=}"; OUT_ISO="/mnt/c/Users/${WIN_USER}/Desktop/JimmyOS-latest.iso" ;;
    *) echo "Unknown arg: $arg" >&2; exit 1 ;;
  esac
done

echo "== JimmyOS build =="
echo "Mode: $MODE"
echo "Dist: $DIST"
echo "Arch: $ARCH"
echo "Out : $OUT_ISO"

if [ "$MODE" = "purge" ]; then
  sudo lb clean --purge
elif [ "$MODE" = "fast" ]; then
  sudo lb clean
fi

# Re-run config if:
# - user asked reconfig/purge
# - or live-build "config stage" marker missing
NEED_CONFIG=0
if [ "$MODE" = "purge" ] || [ "$MODE" = "reconfig" ]; then
  NEED_CONFIG=1
elif [ ! -f .build/config ]; then
  NEED_CONFIG=1
fi

if [ "$NEED_CONFIG" = "1" ]; then
  lb config \
    --distribution "$DIST" \
    --architectures "$ARCH" \
    --binary-images iso-hybrid \
    --archive-areas "main contrib non-free non-free-firmware" \
    --cache true
fi

sudo lb build

ISO="$(ls -t *.iso 2>/dev/null | head -n 1)"
if [ -z "${ISO:-}" ]; then
  echo "No ISO found in current directory." >&2
  exit 1
fi

cp -f "$ISO" "$OUT_ISO"
echo "Copied: $ISO -> $OUT_ISO"
