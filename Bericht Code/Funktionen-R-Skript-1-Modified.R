#####################################
# Pakete usw.

# Läd Hilfsfunktionen
source("Funktionen-R-Skript 2.R")

# bibliotheken
library(tidyverse)

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


# Berechnet Absolute & Relative Häufigkeiten und den Modalwert
berechne_kategoriale_statistiken <- function(titanic.data) {
  
  relevante_spalten <- detect_categorical_columns(titanic.data)
  
  # Leeres Dataframe für Zusammenfassung Modalwerte
  ergebnisse <- data.frame(
    Variable = character(),
    Modalwert = character(),
    Anzahl = integer(),
    Anteil_Prozent = double(),
    stringsAsFactors = FALSE
  )
  
  
  for (col in relevante_spalten) {
    werte <- titanic.data[[col]]
    
    # Häufigkeitstabelle erstellen absolute Häufigkeiten
    # useNA = "ifany" zeigt fehlende Werte an
    tabelle_absolut <- table(werte, useNA = "ifany")
    
    # Relative Häufigkeiten in Prozent
    tabelle_relativ <- prop.table(tabelle_absolut) * 100
    
   
    # 4. Modalwert bestimmen
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
  
  # Modalwerte Ausgeben
  return(ergebnisse)
}

# Testen
kateg_daten <- berechne_kategoriale_statistiken(titanic.data)
print(kateg_daten)


######################################

# Funktion 3

######################################


analyze_categorical_relation <- function(data, var1, var2) {
  
  # Datenvorbereitung & Berechnungen
  # Kreuztabelle erstellen
  tab <- table(data[[var1]], data[[var2]])
  
  # Prozentuale Verteilung
  tab_prop <- prop.table(tab, margin = 1) * 100
  
  #Statistiken
  chi_test <- chisq.test(tab)
  v_score <- calc_cramers_v(tab)
  
  #Wir bauen in die Rückgabe liste einen Data Frame ein für Hypothesen Tests
  
  plot_df <- as.data.frame(tab_prop)
  
  colnames(plot_df) <- c("Gruppe", "Status", "Prozent")
  
  # Rückgabe der Werte als Liste
  results_list <- list(
    tabelle = tab,
    tabelle_prozent = tab_prop,
    chi_sq_test = chi_test,
    cramers_v = v_score,
    plot.data = plot_df
  )
  return(results_list)
}

######################################

# Funktion 4

######################################

cor_metr_dicho <- function(data, metr_var_name, dicho_var_name) {
  # helper functions:
  check_if_col_exists(data, metr_var_name)
  check_if_col_exists(data, dicho_var_name)
  
  check_if_numeric(data, metr_var_name)
  check_if_dichotomous(data, dicho_var_name)
  
  # Daten extrahieren:
  metr <- data[[metr_var_name]]
  dicho <- as.numeric(as.character(data[[dicho_var_name]]))
  
  #NEU: Wir fügen einen Korrelationstest hinzu
  test <- cor.test(metr, dicho)
  
  #NEU: Wir geben anstatt einer Liste einen Data Frame zurück
  result.df <- data.frame(
    var1 = metr_var_name,
    var2 = dicho_var_name,
    cor = round(test$estimate, 3),
    p.val = format.pval(test$p.value, digits = 3),
    significance = ifelse(test$p.value < 0.05, "Ja", "Nein")
  )
  
  
  return(result.df)
  
}

######################################

# Funktion 5

######################################

v.visualiasation <- function(dataset = titanic.data, var.vec){
  #Wir speichern unsere Variablen in einem Vektor 
  var.vec <- var.vec[var.vec != "Survived"]
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
  ggplot(final.data, aes(x = var.string, y = abs.prob, fill = Survived)) +
    
    #Wir erstellen unseren Barplot
    #(stat = identity sorgt dafür das die Daten nicht neugezählt werden)
    geom_bar(stat = "identity", position = "stack") +
    
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

