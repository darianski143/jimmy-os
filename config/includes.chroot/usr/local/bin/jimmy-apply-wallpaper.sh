#!/bin/sh
set -eu

WALLPAPER_URI="file:///usr/share/wallpapers/JimmyOS/jimmy.png"
MARKER="$HOME/.local/share/jimmyos/.wallpaper_applied"

# rulează o singură dată per user
if [ -f "$MARKER" ]; then
  exit 0
fi

mkdir -p "$(dirname "$MARKER")"

# așteaptă să pornească plasmashell + DBus service
i=0
while [ $i -lt 80 ]; do
  if qdbus org.kde.plasmashell /PlasmaShell >/dev/null 2>&1; then
    break
  fi
  i=$((i+1))
  sleep 0.25
done

# dacă tot nu e gata, renunță fără să blocheze login-ul
if ! qdbus org.kde.plasmashell /PlasmaShell >/dev/null 2>&1; then
  exit 0
fi

# Plasma script: setează wallpaper pe toate desktop containments
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var all = desktops();
for (var i=0; i<all.length; i++) {
  var d = all[i];
  d.wallpaperPlugin = 'org.kde.image';
  d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
  d.writeConfig('Image', '$WALLPAPER_URI');
}
"

touch "$MARKER"
exit 0
