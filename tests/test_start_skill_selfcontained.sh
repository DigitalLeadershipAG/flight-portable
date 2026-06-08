#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail() { echo "FAIL: $1"; exit 1; }
for f in professional-voice-en professional-voice-de chat-voice-en chat-voice-de; do
  [ -f "$ROOT/skills/start/stilwerk/$f.yaml" ] || fail "missing bundled profile $f.yaml"
done
grep -q "plugin-root\|plugins/cache\|FLIGHT_PLUGIN_ROOT" "$ROOT/skills/start/SKILL.md" \
  && fail "start/SKILL.md still references plugin-root/CLI cache"
grep -q "stilwerk/" "$ROOT/skills/start/SKILL.md" || fail "start/SKILL.md no longer copies stilwerk profiles"
echo "PASS"
