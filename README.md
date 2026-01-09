## Voraussetzung

Für die Skriptausführung müssen folgende Pakete installiert sein: install.packages(c("tidyverse", "ggplot2"))

## Fehlende Werte (Age)

In Spalte Age fehlen viele Altersangaben. Diese wurden imputiert.

-   **Methode:** Fehlende Altersangaben wurden durch den Durchschnitt der vorhanden Altersangaben von Personen mit dem gleichen Titel aufgefüllt.

## Vorgehensweise

-   Ähnliche Titel wie Ms, Mlle wurden zu Mrs gruppiert.

-   Seltene Titel ("Dr.", "Rev.", ...) wurden in zur Gruppe rare zusammengefasst.
