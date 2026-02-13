#!/bin/bash
set -e
sudo lb clean --purge
lb config \
  --distribution bookworm \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --archive-areas "main contrib non-free non-free-firmware"
sudo lb build
