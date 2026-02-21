#!/bin/bash

# mic delay ca sa existe sesiunea grafica
sleep 0.2

mpv \
  --fullscreen \
  --no-border \
  --ontop \
  --force-window=yes \
  --no-osc \
  --osd-level=0 \
  --no-input-default-bindings \
  --input-conf=/dev/null \
  --input-cursor=no \
  --cursor-autohide=always \
  --really-quiet \
  "/usr/local/share/jimmyos/boot/boot.mp4"

