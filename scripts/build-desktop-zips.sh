#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/dist/desktop"
rm -rf "$OUT"; mkdir -p "$OUT"
[ -f "$ROOT/skills/start/CLAUDE.md.template" ] || cp "$ROOT/templates/CLAUDE.md.template" "$ROOT/skills/start/CLAUDE.md.template"
for d in "$ROOT"/skills/*/; do
  name="$(basename "$d")"
  ( cd "$ROOT/skills" && zip -r -q "$OUT/flight-$name.zip" "$name" -x '*.DS_Store' )
  echo "built flight-$name.zip"
done
ls -1 "$OUT"
