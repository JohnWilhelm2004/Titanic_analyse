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
    Survived = factor(Survived, levels = c(0, 1),
                           labels = c("No", "Yes"))),
    Embarked = fct_recode(as.factor(Embarked),
                          "Southampton" = "S",
                          "Cherbourg" = "C",
                          "Queenstown" = "Q"),
    Pclass = factor(Pclass,  #Überführen der Variable Pclass in einen ordered-factor.
                          levels = c(1, 2, 3),
                          ordered = TRUE))
  )




# ---------------------------------------------------------------------------
# CODE KABINENINFORMATIONEN, DATENTYPEN ELAHA
# ---------------------------------------------------------------------------

# Cabin: leere Einträge als NA setzen
titanic <- titanic %>%
  mutate(Cabin = na_if(Cabin, ""))

# Deck aus Cabin extrahieren 
titanic <- titanic %>%
  mutate(Deck = str_extract(Cabin, "^[A-Za-z]"))

# Kabinennummer extrahieren (Zahlen)
titanic <- titanic %>%
  mutate(CabinNumber = as.numeric(str_extract(Cabin, "[0-9]+")))

# Backbord oder Steuerbord bestimmen
# ungerade Nummer = Steuerbord, gerade = Backbord
titanic <- titanic %>%
  mutate(Side = case_when(
    is.na(CabinNumber) ~ NA_character_,
    CabinNumber %% 2 == 0 ~ "Backbord",
    CabinNumber %% 2 == 1 ~ "Steuerbord"
  ))

# Side und Deck als Faktor codieren
titanic <- titanic %>%
  mutate(
    Side = as.factor(Side),
    Deck = as.factor(Deck)
  )

# ---------------------------------------------------------------------------
# NICHT MEHR BENÖTIGTE VARIABLEN ENTFERNEN
# ---------------------------------------------------------------------------

titanic <- titanic %>%
  select(-PassengerID, -Name, -Ticket, -Cabin, -CabinNumber)

# ---------------------------------------------------------------------------
# DATENSATZ SPEICHERN
# ---------------------------------------------------------------------------

write_csv(titanic, "../Daten/titanic_clean.csv")

# ---------------------------------------------------------------------------
# FERTIGE DATEI
# ---------------------------------------------------------------------------
