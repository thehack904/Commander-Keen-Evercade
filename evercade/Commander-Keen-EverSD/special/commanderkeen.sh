#!/bin/bash

SCRIPT_DIR=$(dirname "$BASH_SOURCE")
slot=$(realpath "${SCRIPT_DIR}/..")

APP="$slot/commanderkeen"
HOME_DIR="$APP/home"
CFG="$HOME_DIR/.CommanderGenius/cgenius.cfg"
GOOD="$HOME_DIR/.CommanderGenius/cgenius-evercade-handheld-good.cfg"
LOG="$slot/commanderkeen-launch.log"

exec >>"$LOG" 2>&1

echo
echo "============================================================"
echo "Commander Keen launch: $(date)"
echo "============================================================"
echo "SCRIPT_DIR=$SCRIPT_DIR"
echo "slot=$slot"
echo "APP=$APP"

echo
echo "--- filesystem ---"
mount | grep -E '/mnt/sdcard|/sdcard' || true

echo
echo "--- runtime files ---"

ls -l "$APP/bin/CGeniusExe" || {
    echo "ERROR: CGeniusExe missing"
    exit 10
}

ls -l /lib/ld-linux-armhf.so.3 || {
    echo "ERROR: ARM dynamic loader missing"
    exit 11
}

#
# Restore the validated Evercade handheld configuration.
#
if [ -f "$GOOD" ]; then
    echo "Restoring validated handheld config."
    cp "$GOOD" "$CFG"
fi

export HOME="$HOME_DIR"
export LD_LIBRARY_PATH="$APP/lib"
export SDL_AUDIODRIVER="${SDL_AUDIODRIVER:-alsa}"

echo
echo "--- environment ---"
echo "HOME=$HOME"
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

#
# Stop Evercade frontend supervisor/menu so Commander Genius gets
# exclusive control of the display.
#
LAUNCH_PID=$(ps | awk '/[b]ash \.\/launch\.sh/ {print $1; exit}')
MENU_PID=$(pidof evercade_menu_neon 2>/dev/null || true)

echo
echo "--- Evercade frontend ---"
echo "LAUNCH_PID=$LAUNCH_PID"
echo "MENU_PID=$MENU_PID"

if [ -n "$LAUNCH_PID" ]; then
    echo "Stopping launcher supervisor."
    kill -STOP "$LAUNCH_PID" 2>/dev/null || true
fi

if [ -n "$MENU_PID" ]; then
    echo "Stopping Evercade menu."

    kill -TERM "$MENU_PID" 2>/dev/null || true
    sleep 1

    if kill -0 "$MENU_PID" 2>/dev/null; then
        kill -KILL "$MENU_PID" 2>/dev/null || true
    fi
fi

sleep 1

echo
echo "--- starting Commander Genius through ELF loader ---"

cd "$APP"

#
# VFAT strips the executable permission from CGeniusExe.
# Calling the ARM ELF interpreter directly avoids requiring the
# executable bit on the program file.
#
/lib/ld-linux-armhf.so.3 \
    --library-path "$APP/lib" \
    "$APP/bin/CGeniusExe"

CG_RC=$?

echo
echo "Commander Genius exited: $CG_RC"

#
# Return control to the stock Evercade frontend.
#
if [ -n "$LAUNCH_PID" ]; then
    echo "Resuming launcher supervisor."
    kill -CONT "$LAUNCH_PID" 2>/dev/null || true
fi

echo "Launcher complete."
echo "============================================================"

exit "$CG_RC"
