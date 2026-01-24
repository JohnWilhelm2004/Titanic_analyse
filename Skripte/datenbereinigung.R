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


# 2 Fehlende NAs durch Southampton ersetzen weil dort die 
# meisten eingestiegen sind
titanic <- titanic %>% 
  mutate(Embarked = replace_na(Embarked, "S"))


# Umwandeln von Sex und Embarked in Faktorwerte zum Auswerten
titanic <- titanic %>%
  mutate(
    Sex = as.factor(Sex),
    Embarked = fct_recode(as.factor(Embarked),
                          "Southampton" = "S",
                          "Cherbourg" = "C",
                          "Queenstown" = "Q"),
    Pclass   = ordered(Pclass, levels = c(1,2,3)) #Überführen der Variable Pclass in einen ordered-factor.
  )




# ---------------------------------------------------------------------------
# CODE KABINENINFORMATIONEN, DATENTYPEN ELAHA
# ---------------------------------------------------------------------------









# ---------------------------------------------------------------------------
# FERTIGE DATEI
# ---------------------------------------------------------------------------
