# Flight installieren — Cowork & Claude Desktop

Flight ist dein Arbeits-Begleiter: Aufgaben merken, Memos festhalten, Dokumente im richtigen Stil erzeugen. Alles wird in einem von dir verbundenen Ordner gespeichert.

## Voraussetzungen

- Claude-Abo **Pro, Max, Team oder Enterprise**.
- **Code-Ausführung aktiviert:** Einstellungen → Capabilities → „Code execution" einschalten (sonst sind Skills ausgegraut).
- Ein **Ordner**, den du mit Claude verbindest — dort landen deine Memos.

## Claude Cowork (ein Befehl)

1. Cowork öffnen, ein Projekt anlegen, deinen Ordner verbinden.
2. Im Terminal diesen Befehl ausführen (Ordnerpfad anpassen):

   ```bash
   curl -fsSL https://raw.githubusercontent.com/REPLACE-ME/flight-portable/portable/install.sh | bash -s -- ~/mein-flight-ordner
   ```

3. Fertig. In Cowork tippst du **keine Slash-Befehle** — bitte Claude einfach in normaler Sprache: „**richte flight hier ein**" oder „**start flight**". Der passende Skill löst automatisch aus und legt `flight-workbench/` im Ordner an. (Echte `/flight-…`-Slash-Befehle gibt es nur in Claude Code / CLI.)

## Claude Desktop (ein Befehl + Hochladen)

Der Upload von Skills passiert in Desktop über die Oberfläche — das kann kein Skript. Darum: erst vorbereiten, dann 7× hochladen.

1. Denselben Befehl wie oben ausführen. Er legt zusätzlich den Ordner **`flight-desktop-skills/`** mit 7 ZIP-Dateien an — dein Vorrat zum Hochladen.
2. In Claude Desktop: **Einstellungen → Capabilities → Skills → „+" / „Upload a skill"**.
3. Lade nacheinander alle 7 ZIPs aus `flight-desktop-skills/` hoch (`flight-start.zip`, `flight-memo.zip`, …). Jeden Skill nach dem Upload **einschalten**.
4. Deinen Ordner mit Claude Desktop verbinden (Project Folder).
5. Den Inhalt von `agents/pilot.md` einmalig in die **Projekt-Instruktionen** kopieren, damit Claude sich wie „pilot" verhält.

## So testest du, dass es läuft

Sag zu Claude: **„merke dir: Testaufgabe XY"**. Danach im Ordner prüfen:

```bash
cat ~/mein-flight-ordner/flight-workbench/memos/tasks-*.md
```
Die Zeile mit „Testaufgabe XY" muss da stehen — und nach Schließen/Öffnen noch vorhanden sein.

## Troubleshooting

- **Skills ausgegraut:** Code-Ausführung ist aus → in Capabilities aktivieren (bei Team/Enterprise ggf. Admin).
- **Memos verschwinden:** Es wurde nicht im verbundenen Ordner gearbeitet → Ordner verbinden, Befehl mit korrektem Pfad erneut ausführen.
- **Keine `/flight-`-Befehle in Cowork/Desktop:** Das ist normal — dort lösen die Skills automatisch über ihre Beschreibung aus. Sprich Claude einfach an („merke dir …", „räum die Aufgaben auf"). Slash-Befehle gibt es nur in Claude Code (CLI).
- **Updates holen (für Maintainer):** `git fetch upstream && git merge upstream/main` im Fork.
