#######################
# Skript 2 Hilfsfunktion:

titanic.data <- read.csv("titanic_clean.csv")

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
  
  # Gib das Array mit den Namen zurück
  return(metrische_spalten)
}

#########################################################################
# Skript 1

# Lade das Helfer-Skript, damit die Funktion 'detect_metric_columns' verfügbar ist
#source("Funktionen-R-Skript-2.R")
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




