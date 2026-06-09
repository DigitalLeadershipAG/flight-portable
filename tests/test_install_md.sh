#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail() { echo "FAIL: $1"; exit 1; }
M="$ROOT/INSTALL.md"
[ -f "$M" ] || fail "INSTALL.md missing"
for needle in "Voraussetzungen" "Claude Cowork" "Claude Desktop" "curl -fsSL" "gh repo clone" "Dropbox" "So testest du" "Troubleshooting"; do
  grep -q "$needle" "$M" || fail "INSTALL.md missing section/marker: $needle"
done
echo "PASS"
