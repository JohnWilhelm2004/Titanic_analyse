######################################################
# Hilfsfunktionen für Funktionen-R-Skript 1


#################################
# Hilfsfunktion für i

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
####################################