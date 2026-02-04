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

####################################
# Hilfsfunktion für ii
####################################


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




##################################
# Hilfsfunktion für iii
##################################
calc_cramers_v <- function(contingency_table) {
  # Hilfsfunktion zur Berechnung von Cramérs V
  # Formel: sqrt(chi_sq / (n * (min(cols, rows) - 1)))
  
  chi_sq <- chisq.test(contingency_table, correct = FALSE)$statistic
  n <- sum(contingency_table)
  dims <- dim(contingency_table)
  
  v <- sqrt(chi_sq / (n * (min(dims) - 1)))
  
  return(as.numeric(v))
}




###################################
#Hilfsfunktion für iv 
###################################


















###################################
#Hilfsfunktion für v) 
###################################

#Wir erstellen eine Hilfsfunktion für die Datentransformation die für
#jede Variable durchgeführt wird 
data.transform <- function(var, dataset) {
  
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