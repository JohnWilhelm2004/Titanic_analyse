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

v.visualiation <- function(dataset = titanic.data, var1, var2, var3, var4 = NULL){
  #Wir speichern unsere Variablen in einem Vektor 
  var.vec <- c(var1, var2, var3, var4)
  
  #Wir speichern die länge für die Indizierung 
  var.amount <- length(var.vec)
  
  #Wir erstellen einen Data Frame an dem wir unsere Daten später anbinden können
  final.data <- data.frame()
  
  #Wir Indizieren über die ganzen Kategoriellen Merkmale und transformieren sie 1 nach dem anderen
  for(i in 1:var.amount){
    #Wir nutzen Rbind um die Sachen unserem Data Frame hinzuzufügen und rufen dann die Hilfsfunktion
    #aus welche unsere Häufigkeiten zu einem Data Frame zusammenfügt 
    final.data <- rbind(final.data, data.transform(var.vec[i], dataset))
  }
  
  #Jetzt erstellen wir mit ggplot den Finalen schritt
  ggplot(final.data, aes(x = var.string, y = abs.prob, fill = var)) +
    
    #Wir erstellen unseren Barplot
    #(stat = identity sorgt dafür das die Daten nicht neugezählt werden)
    geom_bar(stat = "identity") +
    
    #Wir erstellen für jedes der gewählten Merkmale einen Eigenen Barplot 
    facet_wrap(~var, scales = "free_x") +
    
    #Wir nehmen unsere Farbpalette damit das ganze gut aussieht 
    scale_fill_viridis_d(option = "mako", begin = 0.3, end = 0.8) +
    
    #Wir machen unsere Theme auswahl
    theme_minimal(base_size = 12) +
    
    #Wir platzieren Beschriftungen rechts und entfernen doppelte Überschriften
    theme(
      legend.position = "right",
      strip.text = element_blank()
    ) +
    
    #Wir fügen allgemeine Achsenbeschriftung hinzu
    labs(title = "Absolute Häufigkeiten der Kategorialen Merkmale",
         x = "Merkmale",
         y = "Absolute Häufigkeit")
}












































