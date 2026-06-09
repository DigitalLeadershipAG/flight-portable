#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail() { echo "FAIL: $1"; exit 1; }

[ -f "$ROOT/skills/stilcheck/SKILL.md" ]      || fail "stilcheck skill missing"
grep -q "^description:" "$ROOT/skills/stilcheck/SKILL.md" || fail "stilcheck missing description frontmatter"
[ -f "$ROOT/commands/flight-stilcheck.md" ]   || fail "flight-stilcheck command wrapper missing"

# Must be self-contained for Claude Desktop: bundle the 4 style profiles.
for f in professional-voice-en professional-voice-de chat-voice-en chat-voice-de; do
  [ -f "$ROOT/skills/stilcheck/stilwerk/$f.yaml" ] || fail "stilcheck missing bundled profile $f.yaml"
done

# Profile-loading must prefer the workbench, fall back to the bundled skill dir.
grep -q "flight-workbench/stilwerk" "$ROOT/skills/stilcheck/SKILL.md" || fail "stilcheck does not read the installed profile"
grep -q "skill-dir>/stilwerk"       "$ROOT/skills/stilcheck/SKILL.md" || fail "stilcheck has no bundled-profile fallback"
echo "PASS"
