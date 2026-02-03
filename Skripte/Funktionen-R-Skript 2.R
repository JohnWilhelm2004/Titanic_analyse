######################################################
# Hilfsfunktionen für Funktionen-R-Skript 1
#Setup 
library(tidyverse)
titanic.data <- read.csv("titanic_clean.csv")

#################################
# Hilfsfunktion für i

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

###################################
#Hilfsfunktion für v) 

#Wir erstellen eine Hilfsfunktion für die Datentransformation die für
#jede Variable durchgeführt wird 
data.transform <- function(var) {
  
  #Wir setzen unsere Variable auf die Aktuelle 
  curr.var <- var 
  
  #Wir transformieren unsere Daten und nehmen unsere Aktuelle Spalte
  resulted.data <- dataset %>%
    
    #Wir wählen unsere Aktuelle Spalte
    select(var.string = .data[[curr.var]]) %>%
    
    #Wir entfernen alle Fehlenden Werte
    drop_na() %>%
    
    #Wir zählen die Absoluten Häufigkeiten
    count(var.string) %>%
    
    #Wir bennen unsere Variablen um 
    rename(abs.prob = n) %>%
    
    #Wir fügen noch eine Spalte hinzu damit facet_wrap später weiß zu welchem Barplot das gehört
    mutate(var = curr.var)
  
  #Wir geben unsere Formatierte Tabelle an rbind zurück
  return(resulted.data)
}