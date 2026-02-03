## Aufgabe 2
## iv)

titanic_data <- read.csv("titanic_clean.csv")

# Aufgabenstellung: Eine Funktion, die geeignete deskriptive bivariate Statistiken für den
# Zusammengang zwischen einer metrischen und einer dichotomen
# Variablen berechnet und ausgibt.
# -> Punktbiseriale Korrelation (r_pb)


cor_metr_dicho <- function(data, metr_col_name, dicho_col_name) {
  # Helper functions:
  # helper: check if columns exist
  
  metr = data[[metr_col_name]]
  dicho = data[[dicho_col_name]]
  
  # helper: check if metr is numeric
  # helper: check if dicho is dichotomous, check if numeric (0,1), if not: convert?
  
  results = list(
    twosided = cor.test(metr, dicho),
    onsided_greater = cor.test(metr, dicho, alternative = "greater"),
    onsided_less = cor.test(metr, dicho, alternative = "less")
  )
  
  return(results)
  
}

#Test
cor_metr_dicho(titanic_data, "Age", "Survived")

## Helper functions:

