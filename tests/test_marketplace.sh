#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail() { echo "FAIL: $1"; exit 1; }

M="$ROOT/.claude-plugin/marketplace.json"
[ -f "$M" ] || fail "marketplace.json missing"

python3 - "$M" <<'PY' || exit 1
import json, sys
d = json.load(open(sys.argv[1]))
assert d.get("name"), "marketplace needs a name"
assert d.get("owner", {}).get("name"), "marketplace needs owner.name"
plugins = d.get("plugins", [])
hit = [p for p in plugins if p.get("name") == "flight-portable" and p.get("source") == "./"]
assert hit, "marketplace must list the flight-portable plugin with source './'"
assert hit[0].get("description"), "plugin entry needs a description"
print("ok")
PY
echo "PASS"
