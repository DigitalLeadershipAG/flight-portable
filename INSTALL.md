# Flight installieren — Cowork & Claude Desktop

Flight ist dein Arbeits-Begleiter: Aufgaben merken, Memos festhalten, Dokumente im richtigen Stil erzeugen. Alles wird in einem von dir verbundenen Ordner gespeichert.

## Voraussetzungen

- Claude-Abo **Pro, Max, Team oder Enterprise**.
- **Code-Ausführung aktiviert:** Einstellungen → Capabilities → „Code execution" einschalten (sonst sind Skills ausgegraut).
- Ein **Ordner**, den du mit Claude verbindest — dort landen deine Memos.

## Einmalige Einrichtung (Terminal)

Du bekommst von uns die Datei **`flight-portable.zip`** (per Laufwerk, Mail oder Slack) — **kein GitHub-Account nötig**. Entpacken und installieren (Ordnerpfad anpassen):

```bash
unzip flight-portable.zip
./flight-portable/install.sh ~/mein-flight-ordner
```

Das kopiert die Skills und den `pilot`-Agenten nach `~/mein-flight-ordner/.claude/`, legt `CLAUDE.md` an (nur falls noch keine existiert), und erstellt den Ordner **`flight-desktop-skills/`** mit 8 ZIP-Dateien für den Desktop-Upload.

> **Nur Desktop und kein Terminal?** Dann brauchst du `install.sh` gar nicht — entpacke `flight-portable.zip` und nimm direkt die 8 ZIPs aus dem Ordner `flight-portable/flight-desktop-skills/` zum Hochladen (siehe Desktop-Abschnitt).

<details>
<summary>Alternative für Maintainer: per GitHub klonen</summary>

Mit [`gh`](https://cli.github.com/) (eingeloggt, Mitglied der Org **DigitalLeadershipAG**):

```bash
gh repo clone DigitalLeadershipAG/flight-portable
./flight-portable/install.sh ~/mein-flight-ordner
```

Ist das Repo später öffentlich, geht auch der Einzeiler `curl -fsSL https://raw.githubusercontent.com/DigitalLeadershipAG/flight-portable/portable/install.sh | bash -s -- ~/mein-flight-ordner`.
</details>

### Flight in allen Cowork-Ordnern (global, optional)

Standardmäßig gilt Flight nur in dem Ordner, in den du installiert hast. Willst du Flight in **jedem** Cowork-/Claude-Code-Projekt automatisch haben, installiere einmal global:

```bash
./flight-portable/install.sh --global
```

Das legt die Skills, den Agenten und die Befehle in `~/.claude/` ab. Danach ist Flight überall verfügbar; den `flight-workbench/` legt es weiterhin **pro verbundenem Ordner** an, sobald du „start flight" sagst. (Im globalen Modus werden keine Desktop-ZIPs erzeugt — Desktop läuft über den Upload-Weg.)

## Claude Cowork

1. In Cowork ein Projekt anlegen und `~/mein-flight-ordner` verbinden.
2. Du tippst **keine Slash-Befehle** — bitte Claude einfach in normaler Sprache: „**richte flight hier ein**" oder „**start flight**". Der passende Skill löst automatisch aus und legt `flight-workbench/` im Ordner an. (Echte `/flight-…`-Slash-Befehle gibt es nur in Claude Code / CLI.)

## Claude Desktop (+ Hochladen)

Der Upload von Skills passiert in Desktop über die Oberfläche — das kann kein Skript. Die ZIPs hat die Einrichtung oben schon erzeugt.

1. In Claude Desktop: **Einstellungen → Capabilities → Skills → „+" / „Upload a skill"**.
2. Lade nacheinander alle 8 ZIPs aus `~/mein-flight-ordner/flight-desktop-skills/` hoch (`flight-start.zip`, `flight-memo.zip`, …). Jeden Skill nach dem Upload **einschalten**.
3. `~/mein-flight-ordner` mit Claude Desktop verbinden (Project Folder).
4. Den Inhalt von `~/mein-flight-ordner/.claude/agents/pilot.md` einmalig in die **Projekt-Instruktionen** kopieren, damit Claude sich wie „pilot" verhält.

## Team-Setup über Dropbox (geteilter Ordner)

Flight speichert alles als Dateien im verbundenen Ordner. Liegt dieser in **Dropbox**, teilt sich das ganze Team automatisch Aufgaben, Memos, Sitzungsverlauf und erzeugte Dokumente.

**Einmal einrichten (eine Person):**
1. Einen Dropbox-synchronisierten Ordner als gemeinsamen Arbeitsordner wählen.
2. Flight dort hinein installieren:
   ```bash
   ./flight-portable/install.sh ~/Dropbox/unser-flight-ordner
   ```
   Das legt `.claude/` (Skills + Agent + Befehle) **und** den Ordner `flight-desktop-skills/` (die 8 ZIPs) im Ordner ab — beides synct zu allen Kollegen.

**Jeder Kollege:**
- **Cowork:** den synchronisierten Ordner in Cowork verbinden — die Skills sind durch die Dropbox-Sync schon da, **keine eigene Installation nötig**. Einfach mit Claude reden.
- **Desktop:** die 8 ZIPs aus `…/flight-desktop-skills/` einmal hochladen (Skills syncen in Desktop **nicht** über Dropbox).

**Was geteilt wird:** `flight-workbench/memos/` (Aufgaben/Memos), `flight-workbench/history/` (Sitzungsverläufe), `flight-workbench/decisions/` und alle erzeugten Dokumente im Ordner.

**Hinweise:**
- Aufgaben sind **pro Person** getrennt (`tasks-<name>.md`) — jeder sieht alle, jeder pflegt seine eigene. Das minimiert Dropbox-Konflikte.
- Vermeidet, **dieselbe** Datei *gleichzeitig* zu bearbeiten — sonst legt Dropbox „conflicted copy"-Versionen an.
- Achtet darauf, dass der Ordner lokal **verfügbar** ist (nicht „nur online" / Smart Sync), sonst findet Cowork die Skills evtl. nicht.
- `CLAUDE.md` (Sprache + Konventionen) wird mitgeteilt — passt für ein Team.

> Noch nicht in Cowork verifiziert: dass synchronisierte `.claude/`-Skills bei einem Kollegen ohne eigene Installation greifen. Bitte einmal mit einer zweiten Person testen.

## So testest du, dass es läuft

Sag zu Claude: **„merke dir: Testaufgabe XY"**. Danach im Ordner prüfen:

```bash
cat ~/mein-flight-ordner/flight-workbench/memos/tasks-*.md
```
Die Zeile mit „Testaufgabe XY" muss da stehen — und nach Schließen/Öffnen noch vorhanden sein.

## Was kann ich sagen?

In Cowork/Desktop steuerst du Flight per natürlicher Sprache (keine Slash-Befehle). Eine Übersicht der Formulierungen — Aufgaben merken, Sessions, Dokumente erzeugen — steht in **[SPRACHBEFEHLE.md](SPRACHBEFEHLE.md)**.

## Troubleshooting

- **Skills ausgegraut:** Code-Ausführung ist aus → in Capabilities aktivieren (bei Team/Enterprise ggf. Admin).
- **Memos verschwinden:** Es wurde nicht im verbundenen Ordner gearbeitet → Ordner verbinden, Befehl mit korrektem Pfad erneut ausführen.
- **Keine `/flight-`-Befehle in Cowork/Desktop:** Das ist normal — dort lösen die Skills automatisch über ihre Beschreibung aus. Sprich Claude einfach an („merke dir …", „räum die Aufgaben auf"). Slash-Befehle gibt es nur in Claude Code (CLI).
- **Updates holen (für Maintainer):** `git fetch upstream && git merge upstream/main` im Fork.
