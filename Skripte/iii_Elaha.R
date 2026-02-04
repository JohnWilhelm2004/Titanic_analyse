######################################################

# Hilfsfunktionen für Funktionen-R-Skript 1

#######################################

# Hilfsfunktion für iii

titanic.data <- read.csv("titanic_clean.csv")


calc_cramers_v <- function(contingency_table) {
  # Hilfsfunktion zur Berechnung von Cramérs V
  # Formel: sqrt(chi_sq / (n * (min(cols, rows) - 1)))
  
  chi_sq <- chisq.test(contingency_table, correct = FALSE)$statistic
  n <- sum(contingency_table)
  dims <- dim(contingency_table)
  
  v <- sqrt(chi_sq / (n * (min(dims) - 1)))
  
  return(as.numeric(v))
}

#####################################################
  
# R-Skript1 

  
library(tidyverse)
  
# Helfer-Funktionen laden 
   source("Funktionen-R-Skript 2.R")

# Die Helferfunktion laden
source("helfer_funktionen.R")

analyze_categorical_relation <- function(data, var1, var2) {
  # Erstellt eine Kreuztabelle
  tab <- table(data[[var1]], data[[var2]])
  
  # Prozentuale Verteilung (relativ zu den Zeilen)
  tab_prop <- prop.table(tab, margin = 1) * 100
  
  # Chi-Quadrat Test durchführen
  chi_test <- chisq.test(tab)
  
  # Effektstärke über die Helferfunktion aus Skript 2 berechnen
  v_score <- calc_cramers_v(tab)
  
  # Schöne Ausgabe
  cat("--- Bivariate Analyse ---\n")
  cat("Variablen:", var1, "und", var2, "\n\n")
  
  cat("Häufigkeitstabelle:\n")
  print(tab)
  
  cat("\nRelative Häufigkeiten (in %, Zeilenweise):\n")
  print(round(tab_prop, 2))
  
  cat("\nStatistische Kennzahlen:\n")
  cat("- Chi-Quadrat-Wert:", round(chi_test$statistic, 3), "\n")
  cat("- p-Wert:", format.pval(chi_test$p.value, eps = 0.001), "\n")
  cat("- Cramérs V (Effektstärke):", round(v_score, 3), "\n")
  
  # Interpretation der Effektstärke
  interpretation <- case_when(
    v_score < 0.1 ~ "vernachlässigbar",
    v_score < 0.3 ~ "schwach",
    v_score < 0.5 ~ "mittel",
    TRUE ~ "stark"
  )
  cat("- Interpretation: Ein", interpretation, "Zusammenhang.\n")
}