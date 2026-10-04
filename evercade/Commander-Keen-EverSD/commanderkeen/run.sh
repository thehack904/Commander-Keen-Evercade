#!/bin/sh

APP="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

export HOME="$APP/home"
export LD_LIBRARY_PATH="$APP/lib"
export SDL_AUDIODRIVER="${SDL_AUDIODRIVER:-alsa}"

CFG="$HOME/.CommanderGenius/cgenius.cfg"
GOOD="$HOME/.CommanderGenius/cgenius-evercade-handheld-good.cfg"

# ----------------------------------------------------------
# Evercade Original Handheld
#
# Native LCD: 480x272
#
# Commander Genius must not retain desktop/1080p display
# settings on this target. Always restore the validated
# handheld profile before launch.
# ----------------------------------------------------------

if [ -f "$GOOD" ]; then
    cp "$GOOD" "$CFG"
fi

cd "$APP"

echo "===== COMMANDER GENIUS EVERCADE HANDHELD ====="
echo "APP=$APP"
echo "HOME=$HOME"
echo "Display profile: 480x272 native fullscreen"
echo

exec "$APP/bin/CGeniusExe"
