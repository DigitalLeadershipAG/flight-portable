# flight-portable

A lightweight AI work companion for non-technical users — a calm, capable assistant for analyzing documents, discussing topics, and producing precise written outputs, without the complexity of multi-agent orchestration.

This is a **portable build** of [flight](https://github.com/tenzoki/flight) that runs in three places:

- **Claude Code** (CLI) — drop the skills/agent into a project's `.claude/`.
- **Claude Cowork** — same `.claude/` layout in a connected project folder.
- **Claude Desktop** — upload the skills as ZIPs (Settings → Capabilities → Skills).

Its single AI agent is named **pilot**. Everything flight tracks is plain files in a `flight-workbench/` folder inside the folder you connect — there is **no MCP server** and nothing system-wide.

> **Installing it?** See **[INSTALL.md](INSTALL.md)** for the step-by-step guide (German, non-technical) covering both Cowork and Desktop.

## What flight does

- **Analyzes documents and discusses topics.** Bring a PDF, a spec, a transcript — talk it through, get a summary, draft a response.
- **Produces well-styled written outputs.** Markdown by default; also `.pptx`, `.xlsx`, `.docx`, etc. on request. Documents apply a professional-voice stylometric profile; conversational replies apply a leaner chat-voice profile. Deliverables land at the **connected-folder root**, not inside `flight-workbench/`.
- **Tracks open tasks** in `flight-workbench/memos/tasks-<user>.md` — they show up automatically every session. (Not in `CLAUDE.md`, which is shared with other tools.)
- **Files decisions** when you ask (or when a discussion surfaces an insight worth keeping).
- **Logs every session** to `flight-workbench/history/`, so the conversation is durable even if you do not use git.

## What flight is NOT

- Not a code-writing assistant primarily (though it can write code on request).
- Not [fusion](https://github.com/tenzoki/fusion). No orchestrator, no Turn loops, no Coherence checks, no compliance guard, no sub-agent dispatch.
- Not silent. Flight asks before destructive operations.

## Quick start

This is a **private** repo, so install by cloning (needs [`gh`](https://cli.github.com/) and DigitalLeadershipAG org access). Once per machine — adjust the folder path:

```bash
gh repo clone DigitalLeadershipAG/flight-portable
./flight-portable/install.sh /path/to/your/folder
```

This copies the skills into `<folder>/.claude/skills/`, the pilot agent into `<folder>/.claude/agents/`, the slash-command wrappers into `<folder>/.claude/commands/`, creates `CLAUDE.md` (only if missing — your edits are never overwritten), and prepares the Desktop ZIPs in `<folder>/flight-desktop-skills/`. Then just ask Claude to "start flight" (in Claude Code you can also type `/flight-start`).

- **Cowork:** connect the folder, then talk to Claude in natural language (no slash commands).
- **Claude Desktop:** upload the 7 ZIPs from `flight-desktop-skills/` in Settings → Capabilities → Skills.
- **All projects at once:** `./flight-portable/install.sh --global` installs into `~/.claude/`, making flight available in every Cowork/Claude Code project (the workbench is still created per connected folder).

Full step-by-step guide: **[INSTALL.md](INSTALL.md)**.

> If the repo is later made public, the one-liner `curl -fsSL https://raw.githubusercontent.com/DigitalLeadershipAG/flight-portable/portable/install.sh | bash -s -- /path/to/folder` also works.

## The seven skills

In **Claude Code (CLI)** these are real slash commands (`/flight-start`, `/flight-memo`, …). In **Cowork and Claude Desktop** there are no slash commands — the skills trigger automatically from their description, so you just describe what you want ("merke dir …", "start flight"). A German phrasebook of what to say is in **[SPRACHBEFEHLE.md](SPRACHBEFEHLE.md)**.

| Skill | What it does |
|---|---|
| `start`   | Set up or refresh the workbench, read CLAUDE.md, show open tasks |
| `land`    | Close the session — summary to history, carry forward unresolved tasks |
| `memo`    | Capture an open task (or a longer memo) |
| `cleanup` | Strip closed/stale tasks from your task list, archive the strippings |
| `archive` | Move old workbench files into a timestamped archive bundle |
| `unlock`  | Write a permissive permissions file so future sessions skip approval prompts (Claude Code only) |
| `help`    | Explainer. Optional topic: workflow, commands, files, language, style, tasks |

## What gets created in your folder

```
your-folder/
├── CLAUDE.md                        ← project language + flight conventions (Cowork/Code)
├── <prefix>-<your-deliverable>.md   ← documents flight produces for you (folder root, default)
├── .claude/                         ← skills + pilot agent (Cowork/Code)
├── flight-desktop-skills/           ← 7 ZIPs to upload into Claude Desktop
└── flight-workbench/                ← internal scaffolding for flight's own tracking
    ├── history/                     ← one file per session (auto-logged)
    ├── decisions/                   ← important choices you tracked
    ├── memos/                       ← open tasks (tasks-<user>.md) + memos (memos-<user>.md), via memo only
    ├── archive/                     ← cleanup and archive move here
    ├── stilwerk/                    ← style profiles (read-only)
    └── .flight-setup                ← setup marker (when/where)
```

Every file flight creates carries a date-time prefix: `<prefix>-<name>.<ext>`, default `YYYY-MM-DD_HH-MM`. Override via the `FLIGHT_FILE_PREFIX` environment variable (a `date(1)` strftime string) — change it only on a clean project, or sort order becomes inconsistent.

## Language

Default is English. If you work in another language, flight asks once whether to switch the project's language permanently (recorded in `CLAUDE.md`). flight ships professional-voice and chat-voice profiles in English and German; for other languages it reads the English profile and applies the same intent in the target language.

## Maintaining this fork

```bash
git fetch upstream && git merge upstream/main   # pull updates from tenzoki/flight
scripts/build-desktop-zips.sh                   # rebuild the 7 Desktop ZIPs
for t in tests/test_*.sh; do "$t"; done         # run the portability test suite
```

## Requirements

- **Claude Code** v2.0.12+, **Claude Cowork**, or **Claude Desktop** (Pro/Max/Team/Enterprise with code execution enabled).
- No git, Node, or Python required for the core skills. (Producing `.pptx` / `.xlsx` etc. uses Python libraries on request.)

## License

MIT. See [LICENSE](LICENSE). Based on [tenzoki/flight](https://github.com/tenzoki/flight).
