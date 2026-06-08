#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail() { echo "FAIL: $1"; exit 1; }

# Proactive overview offer must be present for both Cowork (pilot) and the start skill.
grep -qi "offer to create an overview" "$ROOT/agents/pilot.md"        || fail "pilot.md missing the overview offer"
grep -qi "offer to create an overview" "$ROOT/skills/start/SKILL.md"  || fail "start skill missing the overview offer"
# Desktop conventions (no agent) must carry it too.
for s in start memo; do
  grep -qi "Existing documents" "$ROOT/skills/$s/SKILL.md" || fail "$s conventions missing the existing-documents note"
done
echo "PASS"
