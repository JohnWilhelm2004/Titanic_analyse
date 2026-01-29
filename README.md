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

str_extract() extrahiert einen bestimmten Teil eines Strings
Der reguläre Ausdruck ^[A-Za-z] bedeutet:
^ → Anfang des Strings
[A-Za-z] → ein einzelner Buchstabe

Somit wird aus "C85" -> "C". Der Buchstabe steht für das Deck des Schiffes

Das Deck kann Hinweise geben auf die soziale Schicht, die Position auf dem Schiff und die Überlebenswahrscheinlichkeit.
Die Information ist analytisch deutlich wertvoller als die vollständige Kabinennummer.













