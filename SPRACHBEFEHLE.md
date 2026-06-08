# Flight per natürlicher Sprache steuern

In **Claude Cowork** und **Claude Desktop** tippst du keine Slash-Befehle — du sagst Claude einfach in normaler Sprache, was du willst. Der passende Skill löst automatisch aus. (Echte `/flight-…`-Slash-Befehle gibt es nur in Claude Code / CLI.)

Hier die wichtigsten Formulierungen:

## Aufgaben & Notizen merken
- „**Merke dir: …**" · „**Notier dir, dass …**" · „**Füg eine Aufgabe hinzu: …**"
- „**Was steht noch offen?**" · „**Zeig mir meine Aufgaben**"
- Längere Notizen: „**Halt das mal fest: …**" → landet als Memo

## Session starten & sauber beenden
- „**Richte flight hier ein**" · „**Start flight**" → legt/aktualisiert den Workbench an, zeigt offene Aufgaben
- „**Lass uns die Session abschließen**" · „**Mach Feierabend**" → Zusammenfassung in die History, offene Aufgaben werden mitgenommen

## Aufräumen & Archivieren
- „**Räum die Aufgabenliste auf**" · „**Wirf erledigte Aufgaben raus**" → entfernt geschlossene/veraltete Tasks (fragt im Zweifel nach), sichert sie ins Archiv
- „**Archivier die alten Workbench-Dateien**" → bündelt Altes nach `flight-workbench/archive/`

## Dokumente & Analyse (das Herzstück)
- Wenn der Ordner schon Dokumente enthält, **bietet Flight beim ersten Mal von selbst an**, einen Überblick zu erstellen — du kannst auch direkt fragen: „**Verschaff dir einen Überblick über die Dateien hier.**"
- „**Fass dieses PDF zusammen**" · „**Lies das durch und nenn mir die Kernpunkte**"
- „**Entwirf eine Antwort an …**" · „**Schreib mir einen Vermerk über …**"
- „**Mach mir daraus eine PowerPoint / ein Excel / ein Word-Dokument**" (.pptx/.xlsx/.docx)
- „**Lass uns über … sprechen**" — gemeinsam durchdenken
- „**Merk dir diese Entscheidung: …**" → legt einen Entscheidungs-Record an

Fertige Dokumente landen im **verbundenen Ordner** (neben `CLAUDE.md`); die Stil-Profile (professional für Dokumente, chat für Gespräche) werden automatisch angewandt.

## Hilfe & Sprache
- „**Was kannst du alles? / Erklär mir flight**"
- „**Lass uns auf Deutsch arbeiten**" → ändert die Projektsprache (in `CLAUDE.md`); danach greifen automatisch die deutschen Stil-Profile

---

**Hinweis:** Der `unlock`-Skill tut in Cowork/Desktop nichts — er betrifft nur Berechtigungen in Claude Code (CLI).

**Wo alles gespeichert wird:** Aufgaben/Memos in `flight-workbench/memos/`, Sitzungsverlauf in `flight-workbench/history/`, Entscheidungen in `flight-workbench/decisions/` — alles im Ordner, den du verbunden hast.
