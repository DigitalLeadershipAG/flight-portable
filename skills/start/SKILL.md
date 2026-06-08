---
description: Initialize the flight workbench in the current project directory. Creates ./flight-workbench/ with subfolders (history, decisions, memos, archive, stilwerk), copies the stylometric profiles, initializes CLAUDE.md (flight's conventions/instruction file) from the template if missing, then reports any open tasks from flight-workbench/memos/tasks-<user>.md. Run once per project, or re-run any time to refresh the stilwerk profiles and verify the layout. Idempotent — never overwrites user content.
allowed-tools: [Read, Write, Bash, Edit, AskUserQuestion]
---

# /flight-start — initialize a flight project

Run this once in any project folder to set up the flight workbench, or re-run it any time to refresh the style profiles and verify the layout.

The skill is **idempotent** and **non-destructive** — it never overwrites CLAUDE.md if one already exists, and never deletes files.

## Step 0 — Confirm where you are

```bash
pwd
```

Report the path to the user. The workbench will be created at `./flight-workbench/` relative to this directory. If the user wanted to start in a different folder, they should cancel and `cd` there first.

## Step 1 — Locate the bundled style profiles

The four style profiles ship **inside this skill** at `<skill-dir>/stilwerk/`. Claude provides this skill's own directory at invocation (look for "Base directory for this skill:" in this prompt's context). Use that directory directly — there is no separate plugin install to locate. The four files are `professional-voice-en.yaml`, `professional-voice-de.yaml`, `chat-voice-en.yaml`, `chat-voice-de.yaml`.

If you cannot determine the skill directory, warn the user that the style profiles could not be installed; the workbench is still usable and `/flight-memo`, history, etc. all work — only the stylometric polish is missing until `/flight-start` is re-run.

## Step 2 — Create the workbench

```bash
mkdir -p ./flight-workbench/history ./flight-workbench/decisions ./flight-workbench/memos ./flight-workbench/archive ./flight-workbench/stilwerk
```

`mkdir -p` is safe to rerun — existing directories are untouched, missing ones are added.

## Step 3 — Install the style profiles

Copy all four YAML profiles from `<skill-dir>/stilwerk/` into `./flight-workbench/stilwerk/`. Always overwrite — the source-of-truth is the bundled skill version, so a refresh on /flight-start re-installs the latest. Use:

```bash
cp "<skill-dir>/stilwerk/professional-voice-en.yaml" ./flight-workbench/stilwerk/
cp "<skill-dir>/stilwerk/professional-voice-de.yaml" ./flight-workbench/stilwerk/
cp "<skill-dir>/stilwerk/chat-voice-en.yaml" ./flight-workbench/stilwerk/
cp "<skill-dir>/stilwerk/chat-voice-de.yaml" ./flight-workbench/stilwerk/
```

Replace `<skill-dir>` with the path resolved in Step 1. After the copy, list `./flight-workbench/stilwerk/` and confirm all four profiles are present.

## Step 4 — Write the setup marker

```bash
printf '{"setup_at":"%s","setup_pwd":"%s","flight":"portable"}\n' "$(date +%Y-%m-%dT%H:%M:%S%z)" "$(pwd -P)" > ./flight-workbench/.flight-setup
```

Harmless to overwrite on re-runs.

## Step 5 — Initialize CLAUDE.md (only if missing)

Check if `./CLAUDE.md` exists.

**If it does NOT exist:** copy the template bundled with this skill at `<skill-dir>/CLAUDE.md.template` to `./CLAUDE.md`. The template is the system-prompt-extension that makes the default Claude session in this project behave as flight; without it, future sessions will not know about flight's conventions.

**If it already exists:** read it. Do NOT overwrite. The user has already curated content here. Report to the user: "Found existing CLAUDE.md — keeping it as is."

## Step 5b — Migrate legacy task/memo data out of CLAUDE.md (one-time)

Older flight versions stored open tasks and memos inside `CLAUDE.md`. Flight no longer does — `CLAUDE.md` is auto-loaded into every session and shared with other tools (e.g. fusion) whose CLAUDE.md upkeep would clobber such data. If a project's CLAUDE.md still holds legacy data, offer to migrate it.

Determine the OS user: `echo "$USER"`. Read `./CLAUDE.md` (if present) and detect any of:

- a `## Open tasks` section with real list items (ignore a `(No open tasks yet...)` placeholder),
- a `## Project memos` section with real content (ignore the placeholder),
- a `## Recent sessions` section with entries.

If none are present (e.g. a fresh slim CLAUDE.md), **skip this step silently** — it is a no-op on every subsequent run.

If any are present, tell the user and ask via `AskUserQuestion`:

> Your `CLAUDE.md` still holds <N> open tasks and <M> memos from an older flight version. Flight now keeps these under `flight-workbench/memos/` so they don't collide with other tools that share CLAUDE.md.
>
> - **Migrate now** (Recommended) — move them into `tasks-<user>.md` / `memos-<user>.md` and remove them from CLAUDE.md.
> - **Leave as-is** — keep them in CLAUDE.md for now (flight will not read them).

On **Migrate now**:

1. Append each open-task line to `flight-workbench/memos/tasks-$USER.md` (create it from its header if missing), preserving the original text and any date prefix.
2. Append the project memos to `flight-workbench/memos/memos-$USER.md` (create from header if missing) under one dated section header `## <YYYY-MM-DD HH:MM> — Migrated from CLAUDE.md`, content verbatim.
3. Do **not** copy `## Recent sessions` entries — they are already covered by `flight-workbench/history/`. Just remove that section.
4. Remove the `## Open tasks`, `## Project memos`, and `## Recent sessions` sections (and any now-dangling `---` separators) from `CLAUDE.md`. Leave everything else untouched — never delete the `**Language:**` line or user-curated conventions.
5. Confirm: "Migrated N tasks and M memos into `flight-workbench/memos/`; removed them from CLAUDE.md."

## Step 6 — Create today's session history file

Get the current timestamp using the configurable prefix format (env var `FLIGHT_FILE_PREFIX`, defaulting to `%Y-%m-%d_%H-%M`). Create the session history file:

```bash
TS="$(date +"${FLIGHT_FILE_PREFIX:-%Y-%m-%d_%H-%M}")"
cat > "./flight-workbench/history/${TS}-session.md" <<EOF
# Session ${TS}

**Started:** $(date +%Y-%m-%d\ %H:%M)
**Status:** active

## Log

(Conversation log — flight appends notable exchanges, decisions reached, and files produced.)
EOF
```

**Run the bash block above as-is.** Both `${TS}` (the filename prefix) and the `**Started:**` line must come from the shell's `date` output — do not construct the filename or the start time from a timestamp you generated yourself. Your internal clock is UTC and would put the file ~2 hours behind local time (in Central European Summer Time).

This file will be appended to throughout the session and finalized at `/flight-land`.

## Step 7 — Gather session-start context

Determine the OS user: `echo "$USER"`. Then gather:

1. **Language** — read the `**Language:**` line from `./CLAUDE.md` (default English).
2. **Open tasks** — read `./flight-workbench/memos/tasks-$USER.md`. Count the open tasks; if any exist, list them. If the file does not exist yet, there are simply no open tasks. (Tasks are no longer stored in CLAUDE.md — that file is shared with other tools.)
3. **Recent sessions** — list the newest 2-3 files in `flight-workbench/history/` matching `*-session.md` by mtime; use each file's `## Summary` one-liner (or its filename) as the recent-session line.

## Step 8 — Report to the user

Output a short, action-first summary. Lead with **what the user can do next**:

> **Flight is ready. Tell me what you'd like to work on, or pick from the open tasks below.**
>
> **Open tasks (N):**
> - <task 1>
> - <task 2>
>
> **Project language:** <lang>
>
> **Last sessions:**
> - <recent session line 1>
> - <recent session line 2>
>
> **Details:** Workbench at `./flight-workbench/`; CLAUDE.md at project root (language + flight conventions only); open tasks at `flight-workbench/memos/tasks-<user>.md`; style profiles under `flight-workbench/stilwerk/`; this session's history at `flight-workbench/history/<TS>-session.md`. Type `/flight-help` for a tour.
>
> In Cowork and Claude Desktop you don't type slash commands — just tell me what you want and the matching skill runs automatically; the /flight-… commands work in Claude Code (CLI).

If there are no open tasks, say so explicitly and prompt for input:

> **Flight is ready. No open tasks recorded — what would you like to work on?**
>
> Project language: <lang>. Type `/flight-help` if you want a tour of what flight can do.

## What this skill does NOT do

- Does not modify an existing `CLAUDE.md`.
- Does not delete any existing files in `flight-workbench/`.
- Does not configure git, set up hooks, or install dependencies.

## Flight conventions (works without the pilot agent)

In Claude Desktop there is no `pilot` agent and no auto-loaded `CLAUDE.md`, so apply these rules directly:

- **Workbench location:** all flight tracking lives under `./flight-workbench/` in the connected folder — `history/`, `decisions/`, `memos/`, `archive/`, `stilwerk/`. Never put tasks or memos in `CLAUDE.md`.
- **Memos & tasks:** open tasks → `flight-workbench/memos/tasks-<user>.md`; longer memos → `flight-workbench/memos/memos-<user>.md` (one file per OS user).
- **Filenames:** `<prefix>-<name>.<ext>`, prefix from `date +"${FLIGHT_FILE_PREFIX:-%Y-%m-%d_%H-%M}"`. Always get timestamps by running `date` in the shell — never from your own clock (it is UTC and will be off by the local offset).
- **Deliverables** the user asks you to produce go to the **connected folder root**, not under `flight-workbench/`.
- **Style:** apply `flight-workbench/stilwerk/professional-voice-<LANG>.yaml` to long-form documents and `chat-voice-<LANG>.yaml` to short chat replies; if the language has no profile, read the `-en` variant and apply its intent.
- Does not require the user to be technical — every step works without git, node, or python.
