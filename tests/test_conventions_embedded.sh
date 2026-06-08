#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail() { echo "FAIL: $1"; exit 1; }
for skill in start memo; do
  grep -q "Flight conventions (works without the pilot agent)" "$ROOT/skills/$skill/SKILL.md" \
    || fail "$skill/SKILL.md missing embedded conventions block"
done
echo "PASS"
