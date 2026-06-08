#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail() { echo "FAIL: $1"; exit 1; }
"$ROOT/scripts/build-desktop-zips.sh" >/dev/null
count=$(ls -1 "$ROOT"/dist/desktop/flight-*.zip 2>/dev/null | wc -l | tr -d ' ')
[ "$count" = "7" ] || fail "expected 7 zips, got $count"
{ unzip -l "$ROOT/dist/desktop/flight-start.zip" || true; } | grep -q "start/SKILL.md" || fail "start zip missing SKILL.md"
{ unzip -l "$ROOT/dist/desktop/flight-start.zip" || true; } | grep -q "start/stilwerk/chat-voice-en.yaml" || fail "start zip missing bundled profile"
echo "PASS"
