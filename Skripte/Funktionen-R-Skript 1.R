#####################################
# Pakete usw.

# Läd Hilfsfunktionen
source("Funktionen-R-Skript 2.R")















#######################################

# Funktion i

#######################################

# Lade das Helfer-Skript, damit die Funktion 'detect_metric_columns' verfügbar ist
berechne_metrische_statistiken <- function(titanic.data) {
  
  # 1. Hilfsfunktion aufrufen
  relevante_spalten <- detect_metric_columns(titanic.data)
  
  # 2. Data Frame für Ergebnisse
  ergebnisse <- data.frame(
    Variable = character(),
    Mittelwert = double(),
    Median = double(),
    Standardabweichung = double(),
    stringsAsFactors = FALSE
  )
  
  # 3. Schleife durch metrische Spalten
  for (col in relevante_spalten) {
    
    # Daten entnehmen
    werte <- titanic.data[[col]]
    
    # Statistiken berechnen, NAs ignoriert
    mean_val <- mean(werte, na.rm = TRUE)
    med_val <- median(werte, na.rm = TRUE)
    sd_val <- sd(werte, na.rm = TRUE)
    
    # Werte Runden und neue Zeile speichern
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
# Testen
metr_daten <- berechne_metrische_statistiken(titanic.data)
print(metr_daten)



























































######################################

# Funktion 2

######################################
































































######################################

# Funktion 3

######################################






































































######################################

# Funktion 4

######################################






































































######################################

# Funktion 5

######################################













































