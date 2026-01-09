# Datenbereinigung
# Aufgabe 1

# Bearbeitet von John und Elaha




library(tidyverse)

# Daten einlesen
titanic <- read_csv("../Daten/titanic.csv")




# ---------------------------------------------------------------------------
# CODE PERSONENBEZOGENE DATEN VON JOHN
# ---------------------------------------------------------------------------

# Spalte mit Titel einfügen
titanic <- titanic %>%
  mutate(Title = str_extract(Name, "[A-Za-z]+\\."))


# Gruppiert gleichbedeutene Titel zusammen
titanic <- titanic %>%
  mutate(Title = case_when(
         # Gruppe Miss (unverheiratete Frauen)
         Title %in% c("Mlle.", "Ms.") ~ "Miss.",
         
         # Gruppe Mrs (verheiratete Frauen)
         Title == "Mme." ~ "Mrs.",
         
         # Gruppe Besondere Titel
         Title %in% c("Don.", "Rev.", "Dr.", "Major.", "Lady.", "Sir.",
                      "Col.", "Capt.", "Countess.", "Jonkheer") ~ "Rare.",
         
         # Rest bleibt gleich
         TRUE ~ Title
         ))

# Übrige Titel: Mr. Mrs. Miss. Master. Rare

# Ersetze NAs mit durchschnittsalter restlicher Titelträger
titanic <- titanic %>%
  group_by(Title) %>%
  mutate(Age = if_else(is.na(Age), mean(Age, na.rm = TRUE), Age)) %>%
  ungroup()




# ---------------------------------------------------------------------------
# CODE KABINENINFORS, DATENTYPEN ELAHA
# ---------------------------------------------------------------------------









# ---------------------------------------------------------------------------
# FERTIGE DATEI
# ---------------------------------------------------------------------------
