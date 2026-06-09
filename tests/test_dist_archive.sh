#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail() { echo "FAIL: $1"; exit 1; }

"$ROOT/scripts/build-dist-archive.sh" >/dev/null
ARC="$ROOT/dist/flight-portable.zip"
[ -f "$ARC" ] || fail "archive not built"

# Archive must be self-contained: installer, skills, and the 8 prebuilt Desktop ZIPs.
{ unzip -l "$ARC" || true; } | grep -q "flight-portable/install.sh"          || fail "archive missing install.sh"
{ unzip -l "$ARC" || true; } | grep -q "flight-portable/skills/start/SKILL.md" || fail "archive missing skills"
n=$({ unzip -l "$ARC" || true; } | grep -c "flight-portable/flight-desktop-skills/flight-.*\.zip" || true)
[ "$n" = "8" ] || fail "archive should ship 8 prebuilt Desktop ZIPs, has $n"

# Unpacked archive must install OFFLINE (no FLIGHT_PORTABLE_SRC, no network) via clone-local detection.
TMP="$(mktemp -d)"; TGT="$(mktemp -d)"; trap 'rm -rf "$TMP" "$TGT"' EXIT
unzip -q "$ARC" -d "$TMP"
bash "$TMP/flight-portable/install.sh" "$TGT" >/dev/null
[ -f "$TGT/.claude/skills/start/SKILL.md" ]    || fail "unpacked install failed (skills)"
[ -f "$TGT/.claude/commands/flight-start.md" ] || fail "unpacked install failed (commands)"
ls "$TGT/flight-desktop-skills/"flight-*.zip >/dev/null 2>&1 || fail "desktop zips not produced in target"
echo "PASS"
