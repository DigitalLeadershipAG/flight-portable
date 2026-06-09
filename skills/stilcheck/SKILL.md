---
description: Check existing text against flight's stylometric profile and report where it deviates — tone, jargon, AI-tells, sentence length, clarity — then optionally produce a revised version. Use when the user says "prüf den Stil", "check the style", "ist das im richtigen Ton", "klingt das nach uns", or hands over a draft or file to vet against the house style. Takes an optional file path or pasted text; if none is given, ask what to check.
argument-hint: [file path or pasted text]
allowed-tools: [Read, Write, Edit, Bash, AskUserQuestion]
---

# stilcheck — check text against the flight style profile

Evaluate a piece of text against flight's stylometric profile, report concrete deviations with their locations, then offer a revised version.

## Step 1 — Get the text to check

If a file path or text was provided as the argument, use it (read the file if it is a path). Otherwise ask: "Welchen Text soll ich prüfen? (Dateipfad oder Text einfügen)"

## Step 2 — Pick the right profile

Two profiles, two purposes:
- **professional-voice** — for documents / long-form prose (memos, summaries, analyses, letters). Default for anything document-like.
- **chat-voice** — for short conversational or verbal text (messages, quick replies).

If it is unclear which applies, ask once via `AskUserQuestion` (Dokument vs. Chat/Nachricht).

Determine the language: detect the text's language, or read the `**Language:**` line from `./CLAUDE.md` (default English). Use the matching profile variant (`-de` / `-en`).

## Step 3 — Load the profile

Read the profile YAML, in this order of preference:
1. `./flight-workbench/stilwerk/<profile>-<lang>.yaml` — the project's installed profile.
2. `<skill-dir>/stilwerk/<profile>-<lang>.yaml` — bundled with this skill (for Claude Desktop, where no workbench exists). `<skill-dir>` is this skill's own directory (look for "Base directory for this skill:" in this prompt's context).
3. the `-en` variant of the same profile — read it and apply its intent in the target language.

`<profile>` is `professional-voice` or `chat-voice`. If no profile can be read at all, tell the user and proceed using the profile's general intent (professional-voice: precise, professional, reader-respecting prose; chat-voice: lean, terse, action-first, no AI tells).

## Step 4 — Evaluate

Judge the text against the loaded profile's rules. Cover at least:
- **Ton & Register** — matches the profile's intended voice?
- **Fachjargon / Buzzwords** — unexplained jargon, filler, hype.
- **AI-Tells** — formulaic phrasing, empty hedging, "In conclusion", em-dash overuse, list-itis where prose is wanted (per the profile).
- **Satzlänge & Klarheit** — overlong sentences, passive constructions, vague subjects.
- **Struktur** — does the format fit (prose vs. bullets) per the profile.

## Step 5 — Report

Output a compact, scannable report:
- **Gesamteinschätzung:** one line plus a simple rating — `passt` / `leichte Abweichungen` / `deutliche Abweichungen`.
- **Befunde:** a bulleted list. Each finding: the **Fundstelle** (quote the offending phrase, or give the line/section) → was abweicht → konkreter Fix.

Do not rewrite the whole text here — that is Step 6.

## Step 6 — Offer a revised version

Ask: "Soll ich eine überarbeitete Fassung im Profil-Stil erstellen?" On yes:
- If the input was a **file**, write the revision as a new deliverable in the folder root (`<prefix>-<name>-stilgeprueft.<ext>`), never overwriting the original unless the user explicitly says so.
- If the input was **pasted text**, return the revised text inline.

Apply the profile when revising. Get the prefix with `date +"${FLIGHT_FILE_PREFIX:-%Y-%m-%d_%H-%M}"` (run `date` in the shell — never type a time from your own clock). Confirm where you saved it.

## What this skill does NOT do

- Does not change the original file without explicit consent.
- Does not write into `CLAUDE.md` or `flight-workbench/` — revisions are deliverables and go to the folder root.
- Does not invent profile rules — it judges against the loaded profile (or its general intent if none is available).
