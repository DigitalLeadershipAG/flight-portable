#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail() { echo "FAIL: $1"; exit 1; }

# Override HOME so the test installs into a throwaway ~/.claude, never the real one.
TMPHOME="$(mktemp -d)"; trap 'rm -rf "$TMPHOME"' EXIT
HOME="$TMPHOME" bash "$ROOT/install.sh" --global >/dev/null

[ -f "$TMPHOME/.claude/skills/start/SKILL.md" ]    || fail "global: skills not installed"
[ -f "$TMPHOME/.claude/agents/pilot.md" ]          || fail "global: agent not installed"
[ -f "$TMPHOME/.claude/commands/flight-start.md" ] || fail "global: command wrappers not installed"
[ -f "$TMPHOME/.claude/skills/start/stilwerk/chat-voice-en.yaml" ] || fail "global: bundled profiles missing"
# Global mode must NOT touch a global CLAUDE.md or create per-folder Desktop ZIPs in HOME.
[ ! -f "$TMPHOME/.claude/CLAUDE.md" ]      || fail "global must not create a global CLAUDE.md"
[ ! -d "$TMPHOME/flight-desktop-skills" ]  || fail "global must not create Desktop ZIPs"
echo "PASS"
