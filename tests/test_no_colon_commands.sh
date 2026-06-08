#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail() { echo "FAIL: $1"; exit 1; }
if grep -rn "/flight:" "$ROOT/skills" "$ROOT/agents" "$ROOT/templates" 2>/dev/null; then
  fail "colon-namespaced /flight: references remain (do not work outside a plugin)"
fi
for f in skills/start/SKILL.md skills/help/SKILL.md; do
  grep -q "just tell me what you want" "$ROOT/$f" || fail "$f missing auto-trigger guidance marker"
done
echo "PASS"
