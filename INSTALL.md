# Flight installieren — Cowork & Claude Desktop

Flight ist dein Arbeits-Begleiter: Aufgaben merken, Memos festhalten, Dokumente im richtigen Stil erzeugen. Alles wird in einem von dir verbundenen Ordner gespeichert.

## Voraussetzungen

- Claude-Abo **Pro, Max, Team oder Enterprise**.
- **Code-Ausführung aktiviert:** Einstellungen → Capabilities → „Code execution" einschalten (sonst sind Skills ausgegraut).
- Ein **Ordner**, den du mit Claude verbindest — dort landen deine Memos.

## Einmalige Einrichtung (Terminal)

Das Repo ist **privat**, deshalb wird per Klon installiert (kein Token-Gefummel mit `curl`). Voraussetzung: [`gh`](https://cli.github.com/) ist installiert und eingeloggt (`gh auth login`), und du bist Mitglied der Organisation **DigitalLeadershipAG**.

Einmal pro Rechner — Ordnerpfad anpassen:

```bash
gh repo clone DigitalLeadershipAG/flight-portable
./flight-portable/install.sh ~/mein-flight-ordner
```

Das kopiert die Skills und den `pilot`-Agenten nach `~/mein-flight-ordner/.claude/`, legt `CLAUDE.md` an (nur falls noch keine existiert), und erstellt den Ordner **`flight-desktop-skills/`** mit 7 ZIP-Dateien für den Desktop-Upload.

> Ist das Repo später öffentlich, geht auch der Einzeiler `curl -fsSL https://raw.githubusercontent.com/DigitalLeadershipAG/flight-portable/portable/install.sh | bash -s -- ~/mein-flight-ordner`.

## Claude Cowork

1. In Cowork ein Projekt anlegen und `~/mein-flight-ordner` verbinden.
2. Du tippst **keine Slash-Befehle** — bitte Claude einfach in normaler Sprache: „**richte flight hier ein**" oder „**start flight**". Der passende Skill löst automatisch aus und legt `flight-workbench/` im Ordner an. (Echte `/flight-…`-Slash-Befehle gibt es nur in Claude Code / CLI.)

## Claude Desktop (+ Hochladen)

Der Upload von Skills passiert in Desktop über die Oberfläche — das kann kein Skript. Die ZIPs hat die Einrichtung oben schon erzeugt.

1. In Claude Desktop: **Einstellungen → Capabilities → Skills → „+" / „Upload a skill"**.
2. Lade nacheinander alle 7 ZIPs aus `~/mein-flight-ordner/flight-desktop-skills/` hoch (`flight-start.zip`, `flight-memo.zip`, …). Jeden Skill nach dem Upload **einschalten**.
3. `~/mein-flight-ordner` mit Claude Desktop verbinden (Project Folder).
4. Den Inhalt von `~/mein-flight-ordner/.claude/agents/pilot.md` einmalig in die **Projekt-Instruktionen** kopieren, damit Claude sich wie „pilot" verhält.

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
