#!/usr/bin/env bash
set -euo pipefail
# Build a self-contained distributable archive (flight-portable.zip) that colleagues
# can unpack and install WITHOUT GitHub:  ./flight-portable/install.sh ~/their-folder
# It also ships the 8 prebuilt Desktop ZIPs so Desktop-only users need nothing else.
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/dist"
STAGE="$OUT/flight-portable"
ARCHIVE="$OUT/flight-portable.zip"

rm -rf "$STAGE" "$ARCHIVE"
mkdir -p "$STAGE"

# Everything the installer + runtime need.
cp -R "$ROOT/skills" "$ROOT/agents" "$ROOT/commands" "$ROOT/stilwerk" "$ROOT/templates" "$STAGE/"
cp -R "$ROOT/.claude-plugin" "$STAGE/"
cp "$ROOT/install.sh" "$ROOT/INSTALL.md" "$ROOT/SPRACHBEFEHLE.md" "$ROOT/README.md" "$ROOT/LICENSE" "$STAGE/"

# Prebuild the 8 Desktop ZIPs and ship them inside the archive.
"$ROOT/scripts/build-desktop-zips.sh" >/dev/null
mkdir -p "$STAGE/flight-desktop-skills"
cp "$ROOT"/dist/desktop/flight-*.zip "$STAGE/flight-desktop-skills/"

( cd "$OUT" && zip -r -q "flight-portable.zip" "flight-portable" -x '*.DS_Store' )
rm -rf "$STAGE"

echo "built: $ARCHIVE"
unzip -l "$ARCHIVE" | awk 'NR==1||/flight-portable\/(install.sh|INSTALL.md|skills\/start\/SKILL.md|flight-desktop-skills\/flight-start.zip)/'
