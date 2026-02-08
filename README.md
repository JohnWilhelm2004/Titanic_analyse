# Titanic_analyse
Gruppenarbeit Wissenschaftliches Arbeiten. Mitglieder: John Wilhelm, Lukas König, Annika Homm, Elaha Bahir

Dieses Repository enthält R‑Skripte zur deskriptiven Analyse und Visualisierung des aufbereiteten Titanic‑Datensatzes (`titanic_clean.csv`). Der Fokus liegt auf klar strukturierten Funktionen, die im Rahmen der Aufgabenstellung gezielt metrische, kategoriale sowie bivariate Zusammenhänge analysieren.

Die Funktionen sind bewusst modular aufgebaut:

* Funktionen‑R‑Skript 1: Analyse‑ und Visualisierungsfunktionen
* Funktionen‑R‑Skript 2: interne Hilfsfunktionen (Helper), die von Skript 1 genutzt werden

---

## Datengrundlage

Der verwendete Datensatz `titanic_clean.csv` ist eine vorverarbeitete Version des originalen Titanic‑Datensatzes. Er enthält ausschließlich analysegeeignete Variablen, z. B.:

* metrisch: `Age`, `Fare`
* kategorial: `Sex`, `Survived`, `Embarked`, `Deck`, `Side`

Alle Funktionen sind so geschrieben, dass sie robust mit fehlenden Werten (NA) umgehen.

---

## Hilfsfunktionen (Funktionen‑R‑Skript 2)

Diese Funktionen werden nicht direkt zur Analyse verwendet, sondern unterstützen andere Funktionen intern. Ziel: Code sauber, wiederverwendbar und gut wartbar halten.

### 1. `detect_metric_columns(data)`

Aufgabe:
Erkennt automatisch alle metrischen Variablen im Datensatz.

* Jede Spalte wird überprüft
* Es werden nur numerische bzw. ganzzahlige Variablen ausgewählt
* Faktor‑Variablen werden explizit ausgeschlossen

Warum sinnvoll?
Die Analysefunktionen müssen nicht wissen, wie viele oder welche metrischen Variablen existieren. Das macht den Code flexibel für andere Datensätze.

---

### 2. `detect_categorical_columns(data)`

Aufgabe:
Identifiziert alle kategorialen Variablen (Factor, Character, Logical).

Warum sinnvoll?
Kategoriale Variablen benötigen andere statistische Methoden (Häufigkeiten, Modalwert). Diese Trennung ist zentral für saubere Statistik.

---

### 3. `calc_cramers_v(contingency_table)`

Aufgabe:
Berechnet Cramérs V als Effektstärke für den Zusammenhang zweier kategorialer Variablen.

Statistischer Hintergrund:
* basiert auf dem Chi‑Quadrat‑Test
* Wertebereich: 0 (kein Zusammenhang) bis 1 (starker Zusammenhang)

Warum notwendig?
Der Chi‑Quadrat‑Test allein sagt nur ob ein Zusammenhang existiert, nicht wie stark er ist.

---

### 4. Validierungs‑ & Umwandlungsfunktionen

* `check_if_col_exists()` → prüft, ob eine Variable existiert
* `check_if_numeric()` → stellt sicher, dass eine Variable metrisch ist
* `check_if_dichotomous()` → überprüft, ob eine Variable nur zwei Ausprägungen hat
* `get_dichotomous_vals()` → wandelt nicht‑numerische dichotome Variablen in 0/1 um

Diese Checks verhindern statistische Fehlanwendungen (z. B. Korrelation mit nicht‑dichotomen Variablen).

---

### 5. `data.transform(var, dataset)`

Aufgabe:
Bereitet eine einzelne kategoriale Variable für Visualisierungen vor.
* Entfernt fehlende Werte
* Zählt absolute Häufigkeiten
* Fügt eine Variable zur späteren Facettierung hinzu

Warum sinnvoll?
Erlaubt es, mehrere Variablen in einem einzigen ggplot‑Objekt darzustellen.

---

## Analysefunktionen (Funktionen‑R‑Skript 1)

### Funktion i: `berechne_metrische_statistiken(data)`

Ziel:
Deskriptive Statistik für metrische Variablen.

Berechnet:
* Mittelwert
* Median
* Standardabweichung

Bezug zur Aufgabe:
Erfüllt Teilaufgabe 2.a.i – kompakte Übersicht über zentrale Lage & Streuung (z. B. Alter, Ticketpreis).

---

### Funktion ii: `berechne_kategoriale_statistiken(data)`

Ziel:
Deskriptive Statistik für kategoriale Variablen.

Berechnet & gibt aus:
* absolute Häufigkeiten
* relative Häufigkeiten (in %)
* Modalwert

Warum wichtig?
Zentrale Grundlage für alle späteren bivariaten Analysen (z. B. Geschlechterverteilung, Überlebensrate).

---

### Funktion iii: `analyze_categorical_relation(data, var1, var2)`

Ziel:
Untersuchung des Zusammenhangs zwischen zwei kategorialen Variablen.

Berechnet:
* Kreuztabelle
* Zeilenprozente
* Chi‑Quadrat‑Test
* Cramérs V inkl. verbaler Interpretation

---

### Funktion iv: `cor_metr_dicho(data, metr_var, dicho_var)`

Ziel:
Zusammenhang zwischen metrischer und dichotomer Variable.

Methode:
* Punkt‑biseriale Korrelation (über Pearson‑Korrelation)
* zweiseitiger & einseitiger Test

---

### Funktion v: `v.visualiation(dataset, var1, var2, var3, var4 = NULL)`

Ziel:
Gemeinsame Visualisierung von 3–4 kategorialen Variablen.

Darstellung:
* Absolute Häufigkeiten
* Facettierte Barplots
* Einheitliches Design mit `ggplot2`

Warum stark?
Erlaubt schnellen visuellen Vergleich mehrerer Merkmale (z. B. `Sex`, `Embarked`, `Deck`).

---

## Fazit

Dieses Funktions‑Setup ermöglicht eine saubere Trennung von Analyse & Hilfslogik, eine reproduzierbare Statistik und eine klare Dokumentation.

