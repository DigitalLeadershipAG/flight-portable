#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail() { echo "FAIL: $1"; exit 1; }
if grep -rn "claude --agent\|--plugin-dir" "$ROOT/skills" "$ROOT/agents" 2>/dev/null; then
  fail "found claude-CLI dispatch references"
fi
echo "PASS"
