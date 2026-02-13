#!/bin/bash

echo "Welcome to JimmyOS!"
echo "Setting up your system..."

# ensure flathub exists
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true

# install Spotify (extra-data works best on real system, not in chroot)
flatpak install -y --system flathub com.spotify.Client || true

# update flatpak apps
flatpak update -y || true

# mark as done
systemctl disable jimmy-firstboot.service || true
rm -f /etc/systemd/system/jimmy-firstboot.service || true
