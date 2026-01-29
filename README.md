## Voraussetzung

Für die Skriptausführung müssen folgende Pakete installiert sein: install.packages(c("tidyverse", "ggplot2"))

## Fehlende Werte (Age)

In Spalte Age fehlen viele Altersangaben. Diese wurden imputiert.

-   **Methode:** Fehlende Altersangaben wurden durch den Durchschnitt der vorhanden Altersangaben von Personen mit dem gleichen Titel aufgefüllt.

## Vorgehensweise

-   Ähnliche Titel wie Ms, Mlle wurden zu Mrs gruppiert.

-   Seltene Titel ("Dr.", "Rev.", ...) wurden in zur Gruppe rare zusammengefasst.

-   

## Überführung der Variable Pclass in einen ordered factor

factor() wandelt eine numerische oder textuelle Variable in eine kategoriale Variable um.
Mit ordered = TRUE wird zusätzlich festgelegt, dass zwischen den Kategorien eine natürliche Rangordnung existiert.
levels = c(1, 2, 3) definiert explizit die Reihenfolge der Klassen: 1 = Erste Klasse, 2 = Zweite Klasse, 3 = Dritte Klasse
Dies ermöglicht korrekte Vergleiche zwischen Klassen. Das ist wichtig für Regressionen und ordinale Modelle. Zudem verhindert es, dass Pclass fälschlich als reine Zahl interpretiert wird.

## Umwandlung leerer Einträge in NA

na_if() ersetzt bestimmte Werte durch NA
leere Zeichenketten ("") → NA
Leere Strings gelten in R nicht automatisch als fehlende Werte.
Durch die Umwandlung zu NA können fehlende Kabinen korrekt erkannt, gezählt und statistisch verarbeitet werden.

## Extraktion des Decks aus Cabin

str_extract() extrahiert einen bestimmten Teil eines Strings.
Der reguläre Ausdruck ^[A-Za-z] bedeutet:
^ → Anfang des Strings
[A-Za-z] → ein einzelner Buchstabe

Somit wird aus "C85" -> "C". Der Buchstabe steht für das Deck des Schiffes.

Das Deck kann Hinweise geben auf die soziale Schicht, die Position auf dem Schiff und die Überlebenswahrscheinlichkeit.
Die Information ist analytisch deutlich wertvoller als die vollständige Kabinennummer.

## Extraktion der Kabinennummer

str_extract(Cabin, "[0-9]+") extrahiert alle Ziffern aus dem String.
[0-9]+ bedeutet: eine oder mehrere aufeinanderfolgende Zahlen.
as.numeric() wandelt das Ergebnis in eine Zahl um. Diese numerische Form ist notwendig für mathematische Operationen.

##Bestimmung von Backbord oder Steuerbord

case_when() ist eine vektorbasierte If-Else-Struktur.
%% ist der Modulo-Operator. Dieser prüft, ob eine Zahl gerade oder ungerade ist.

Logik:
Gerade Kabinennummer → Backbord
Ungerade Kabinennummer → Steuerbord
Fehlende Kabinennummer → NA

Bedeutung für die Analyse
Diese neue Variable, erzeugt eine räumliche Information und kann mit Überlebensraten oder Decks kombiniert analysiert werden.

##Entfernen nicht mehr benötigter Variablen

select() wählt Variablen aus.
Das Minuszeichen (-) entfernt Variablen gezielt aus dem Datensatz.
Warum entferne ich genau diese Variablen? 
- PassengerID	ist eine Reine ID und KEIN Analysewert.
- Name enthält persönliche Informationen und ist nicht modellrelevant.
Ticket beeinhaltet eine hohe Varianz und ist kaum interpretierbar
Cabin	wurde bereits in sinnvollere Variablen zerlegt.

Vorteil:
- Übersichtlicher Datensatz
- Fokus auf analyse­relevante Variablen
- Weniger Rauschen in statistischen Modellen

## Speichern des bereinigten Datensatzes

write_csv() speichert den aktuellen Datensatz als CSV-Datei
Der neue Datensatz enthält nur noch vorverarbeitete, analysierbare Variablen.
Bedeutung für das Projekt:
- Reproduzierbarkeit der Analyse
- Klare Trennung zwischen Rohdaten und bereinigten Daten
- Einbindung in das GitHub-Repository für Gruppenarbeit










