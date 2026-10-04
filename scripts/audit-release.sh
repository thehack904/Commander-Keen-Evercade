#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
PAYLOAD="$ROOT/evercade/Commander-Keen-EverSD"

echo "Auditing: $ROOT"

test -d "$PAYLOAD/commanderkeen"
test -f "$PAYLOAD/game/commanderkeen"
test -f "$PAYLOAD/game/commanderkeen.json"
test -f "$PAYLOAD/special/commanderkeen.sh"

for f in \
  commanderkeen0.png \
  commanderkeen0_hd.png \
  commanderkeen0_1080.png \
  commanderkeen_gamebanner.png
do
  test -f "$PAYLOAD/game/$f"
done

if find "$ROOT" -type f \( \
  -iname '*.ck1' -o -iname '*.ck2' -o -iname '*.ck3' -o \
  -iname '*.ck4' -o -iname '*.ck5' -o -iname '*.ck6' -o \
  -iname 'keen*.exe' \
\) -print | grep -q .; then
  echo "ERROR: Commander Keen game data found."
  exit 1
fi

if grep -RInaE --binary-files=text '/home/[^/[:space:]]+/' \
  "$PAYLOAD" 2>/dev/null; then
  echo "ERROR: Home-directory path found in release payload."
  exit 1
fi

if command -v readelf >/dev/null 2>&1; then
  while IFS= read -r -d '' f; do
    if readelf -h "$f" >/dev/null 2>&1; then
      if readelf -d "$f" 2>/dev/null | grep -Eq '\((RPATH|RUNPATH)\)'; then
        echo "ERROR: RPATH/RUNPATH found: $f"
        exit 1
      fi
    fi
  done < <(find "$PAYLOAD" -type f -print0)
fi

echo "PASS: release payload audit"
