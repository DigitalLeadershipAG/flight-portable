#!/usr/bin/env bash
set -euo pipefail

# install.sh — set up flight-portable for Cowork / Claude Code, and prepare Desktop ZIPs.
#   Per folder (default):  ./flight-portable/install.sh /path/to/connected/folder
#   Global (all projects): ./flight-portable/install.sh --global
#       → installs into ~/.claude/ so flight is available in EVERY Cowork/Claude Code project.
#         The flight-workbench/ (memos etc.) is still created per connected folder at runtime.
#   (no folder arg → installs into the current directory)

FORK_TARBALL_URL="https://github.com/DigitalLeadershipAG/flight-portable/archive/refs/heads/portable.tar.gz"

GLOBAL=0
if [ "${1:-}" = "--global" ]; then GLOBAL=1; shift; fi
TARGET="${1:-$PWD}"

say() { printf '\033[1m%s\033[0m\n' "$*"; }

# 1. Resolve source, in order of preference:
#    a) FLIGHT_PORTABLE_SRC env (tests/dev)
#    b) the repo this script lives in (run as ./install.sh from a clone — no network, works for private repos)
#    c) download the tarball (only works for a public repo)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo '')"
if [ -n "${FLIGHT_PORTABLE_SRC:-}" ] && [ -d "$FLIGHT_PORTABLE_SRC/skills" ]; then
  SRC="$FLIGHT_PORTABLE_SRC"
  CLEANUP=""
elif [ -n "$SCRIPT_DIR" ] && [ -d "$SCRIPT_DIR/skills" ]; then
  SRC="$SCRIPT_DIR"
  CLEANUP=""
else
  TMP="$(mktemp -d)"; CLEANUP="$TMP"
  say "Downloading flight-portable…"
  curl -fsSL "$FORK_TARBALL_URL" | tar -xz -C "$TMP"
  SRC="$(find "$TMP" -maxdepth 1 -type d -name 'flight-portable*' | head -1)"
fi
[ -d "$SRC/skills" ] || { echo "ERROR: source has no skills/ — bad download?"; exit 1; }

# 1b. Global mode — install into ~/.claude/ so flight is available in all projects.
if [ "$GLOBAL" = "1" ]; then
  DEST="$HOME/.claude"
  say "Installing flight GLOBALLY into: $DEST (available in all Cowork / Claude Code projects)"
  mkdir -p "$DEST/skills" "$DEST/agents"
  cp -R "$SRC"/skills/* "$DEST/skills/"
  cp "$SRC/agents/pilot.md" "$DEST/agents/"
  if [ -d "$SRC/commands" ]; then
    mkdir -p "$DEST/commands"
    cp "$SRC"/commands/*.md "$DEST/commands/"
  fi
  echo "  • Skills, pilot agent and commands installed globally."
  echo "  • No global CLAUDE.md changed; no Desktop ZIPs (those are per-folder)."
  echo "  • The flight-workbench/ is created in whichever folder you connect, when you start flight."
  if [ -n "$CLEANUP" ]; then rm -rf "$CLEANUP"; fi
  say "Done. In any project: connect a folder and ask Claude to 'start flight'."
  exit 0
fi

# 2. Cowork / CLI track — copy into the connected folder's .claude/.
say "Installing flight into: $TARGET"
mkdir -p "$TARGET/.claude/skills" "$TARGET/.claude/agents"
cp -R "$SRC"/skills/* "$TARGET/.claude/skills/"
cp "$SRC/agents/pilot.md" "$TARGET/.claude/agents/"
if [ -d "$SRC/commands" ]; then
  mkdir -p "$TARGET/.claude/commands"
  cp "$SRC"/commands/*.md "$TARGET/.claude/commands/"
fi
if [ -f "$TARGET/CLAUDE.md" ]; then
  echo "  • CLAUDE.md exists — left unchanged."
else
  cp "$SRC/templates/CLAUDE.md.template" "$TARGET/CLAUDE.md"
  echo "  • CLAUDE.md created."
fi

# 3. Desktop track — build the 7 ZIPs into the target so colleagues can upload them.
if command -v zip >/dev/null 2>&1; then
  say "Preparing Desktop skill ZIPs…"
  DESK="$TARGET/flight-desktop-skills"
  rm -rf "$DESK"; mkdir -p "$DESK"
  for d in "$SRC"/skills/*/; do
    name="$(basename "$d")"
    ( cd "$SRC/skills" && zip -r -q "$DESK/flight-$name.zip" "$name" -x '*.DS_Store' )
  done
  echo "  • 7 ZIPs in: $DESK"
elif [ -d "$SRC/flight-desktop-skills" ]; then
  # Distributed package archive ships prebuilt ZIPs — use them when 'zip' is unavailable.
  say "Copying prebuilt Desktop skill ZIPs…"
  DESK="$TARGET/flight-desktop-skills"
  rm -rf "$DESK"; mkdir -p "$DESK"
  cp "$SRC"/flight-desktop-skills/*.zip "$DESK"/
  echo "  • prebuilt ZIPs in: $DESK"
else
  echo "  • 'zip' not found and no prebuilt ZIPs — Desktop ZIPs skipped (Cowork install is complete)."
fi

if [ -n "$CLEANUP" ]; then rm -rf "$CLEANUP"; fi
say "Done. Cowork/CLI: open this folder and run '/flight-start' (or just ask Claude to 'start flight')."
say "Desktop: upload each ZIP in flight-desktop-skills/ — see INSTALL.md."
