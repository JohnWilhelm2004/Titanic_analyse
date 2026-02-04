#######################
# Skript 2 Hilfsfunktion:

titanic.data <- read.csv("titanic_clean.csv")

########################
# i Hilfsfunktion
########################



# Name metrischer Spalten
detect_metric_columns <- function(titanic.data) {
  # Ergebnisse Spaltennamen
  metrische_spalten <- c()
  
  # Schleife durch alle Spaltennamen des Datensatzes
  for (col_name in names(titanic.data)) {
    
    # Spalte auf numerisch Prüfen
    if ((is.numeric(titanic.data[[col_name]]) || is.integer(titanic.data)) && !is.factor(titanic.data)) {
      # Wenn ja, füge den Namen zum Array hinzu
      metrische_spalten <- c(metrische_spalten, col_name)
    }
  }
  # Gibt Array mit Namen zurück
  return(metrische_spalten)
}

########################
# ii Hilfsfunktion
########################

# Name Kategorieller Spalten
detect_categorical_columns <- function(titanic.data) {
  kategoriale_spalten <- c()
  
  for (col_name in names(titanic.data)) {
    # Wir prüfen: Ist es ein FAKTOR, TEXT (character) oder LOGISCH (TRUE/FALSE)?
    if (is.factor(titanic.data[[col_name]]) || is.character(titanic.data[[col_name]]) || is.logical(titanic.data[[col_name]])) {
      kategoriale_spalten <- c(kategoriale_spalten, col_name)
    }
  }
  # Gibt Array mit Namen zurück
  return(kategoriale_spalten)
}



#########################################################################
# Skript 1

# Lade das Helfer-Skript, damit die Funktion 'detect_metric_columns' verfügbar ist
source("Funktionen-R-Skript-2.R")
berechne_metrische_statistiken <- function(titanic.data) {
  
  # 1. Nutzung der Helferfunktion: Welche Spalten sind metrisch?
  relevante_spalten <- detect_metric_columns(titanic.data)
  
  # 2. Erstellen eines leeren Dataframes für die Ergebnisse
  ergebnisse <- data.frame(
    Variable = character(),
    Mittelwert = double(),
    Median = double(),
    Standardabweichung = double(),
    stringsAsFactors = FALSE
  )
  
  # 3. Schleife durch alle gefundenen metrischen Spalten
  for (col in relevante_spalten) {
    
    # Daten der aktuellen Spalte auslesen
    werte <- titanic.data[[col]]
    
    # Berechnung der Statistiken (na.rm = TRUE ignoriert fehlende Werte)
    mean_val <- mean(werte, na.rm = TRUE)
    med_val <- median(werte, na.rm = TRUE)
    sd_val <- sd(werte, na.rm = TRUE)
    
    # Speichern der Werte in einer neuen Zeile
    # Wir runden auf 2 Nachkommastellen für bessere Lesbarkeit
    neue_zeile <- data.frame(
      Variable = col,
      Mittelwert = round(mean_val, 2),
      Median = round(med_val, 2),
      Standardabweichung = round(sd_val, 2)
    )
    
    # Die neue Zeile an das Ergebnis-Dataframe anhängen
    ergebnisse <- rbind(ergebnisse, neue_zeile)
  }
  
  # 4. Rückgabe der kompletten Tabelle
  return(ergebnisse)
}

metr_daten <- berechne_metrische_statistiken(titanic.data)
print(metr_daten)

#########################
# Funktion ii
#########################

# Aufgabe (ii): Deskriptive Statistiken für kategoriale Variablen
# Berechnet Absolute & Relative Häufigkeiten und den Modalwert
berechne_kategoriale_statistiken <- function(titanic.data) {
  
  relevante_spalten <- detect_categorical_columns(titanic.data)
  
  # Leeres Dataframe für die Zusammenfassung (Modalwerte)
  ergebnisse <- data.frame(
    Variable = character(),
    Modalwert = character(),
    Anzahl = integer(),
    Anteil_Prozent = double(),
    stringsAsFactors = FALSE
  )
  
  print("--- Detaillierte Häufigkeiten ---")
  
  for (col in relevante_spalten) {
    werte <- titanic.data[[col]]
    
    # 1. Häufigkeitstabelle erstellen (Absolut)
    # useNA = "ifany" zeigt auch fehlende Werte an, falls es welche gibt
    tabelle_absolut <- table(werte, useNA = "ifany")
    
    # 2. Relative Häufigkeiten (Prozent)
    tabelle_relativ <- prop.table(tabelle_absolut) * 100
    
    # 3. Ausgabe der Details in die Konsole (damit man alles sieht)
    cat("\nVariable:", col, "\n")
    print(rbind(Absolut = tabelle_absolut, Prozent = round(tabelle_relativ, 2)))
    
    # 4. Modalwert bestimmen (Der Wert, der am häufigsten vorkommt)
    # which.max gibt die Position des Maximums, names() gibt den Namen dazu
    modal_name <- names(which.max(tabelle_absolut))
    modal_anzahl <- max(tabelle_absolut)
    modal_anteil <- max(tabelle_relativ)
    
    # Zusammenfassung speichern
    neue_zeile <- data.frame(
      Variable = col,
      Modalwert = modal_name,
      Anzahl = modal_anzahl,
      Anteil_Prozent = round(modal_anteil, 2)
    )
    
    ergebnisse <- rbind(ergebnisse, neue_zeile)
  }
  
  print("---------------------------------")
  
  # Gibt die Übersichtstabelle der Modalwerte zurück
  return(ergebnisse)
}

kateg_daten <- berechne_kategoriale_statistiken(titanic.data)
print(kateg_daten)



