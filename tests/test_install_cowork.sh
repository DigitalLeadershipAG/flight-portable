#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail() { echo "FAIL: $1"; exit 1; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
FLIGHT_PORTABLE_SRC="$ROOT" bash "$ROOT/install.sh" "$TMP" >/dev/null
[ -f "$TMP/.claude/skills/start/SKILL.md" ]  || fail "skills not copied into .claude/skills"
[ -f "$TMP/.claude/skills/memo/SKILL.md" ]   || fail "memo skill missing"
[ -f "$TMP/.claude/agents/pilot.md" ]        || fail "agent not copied"
[ -f "$TMP/.claude/commands/flight-start.md" ] || fail "slash-command wrappers not copied"
[ -f "$TMP/.claude/commands/flight-memo.md" ]  || fail "memo command wrapper missing"
[ -f "$TMP/CLAUDE.md" ]                       || fail "CLAUDE.md not created"
[ -f "$TMP/.claude/skills/start/stilwerk/chat-voice-en.yaml" ] || fail "bundled profiles missing in installed skill"
echo "USER EDIT" >> "$TMP/CLAUDE.md"
FLIGHT_PORTABLE_SRC="$ROOT" bash "$ROOT/install.sh" "$TMP" >/dev/null
grep -q "USER EDIT" "$TMP/CLAUDE.md" || fail "install clobbered existing CLAUDE.md"
echo "PASS"
