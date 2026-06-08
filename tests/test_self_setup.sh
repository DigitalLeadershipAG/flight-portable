#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail() { echo "FAIL: $1"; exit 1; }

# The old "make the user run start first / do not bootstrap" gate must be gone.
if grep -rni "do not bootstrap" "$ROOT/agents" "$ROOT/skills" "$ROOT/templates" 2>/dev/null; then
  fail "text still tells the model not to bootstrap the workbench"
fi
if grep -rniE "run .*flight-start.* first" "$ROOT/agents" "$ROOT/skills" "$ROOT/templates" 2>/dev/null; then
  fail "text still tells the user to run start first"
fi

# Self-setup instruction must be present where each environment needs it.
grep -qi "set it up yourself" "$ROOT/agents/pilot.md" || fail "pilot.md missing self-setup instruction"
for s in start memo; do
  grep -qi "No setup step needed" "$ROOT/skills/$s/SKILL.md" || fail "$s skill missing self-setup note"
done
echo "PASS"
