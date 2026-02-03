## Aufgabe 2
## iv)

titanic_data <- read.csv("titanic_clean.csv")

# Aufgabenstellung: Eine Funktion, die geeignete deskriptive bivariate Statistiken für den
# Zusammengang zwischen einer metrischen und einer dichotomen
# Variablen berechnet und ausgibt.
# -> Punktbiseriale Korrelation (r_pb)


cor_metr_dicho <- function(data, metr_var_name, dicho_var_name) {
  # Helper functions:
  # helper: check if columns exist
  
  metr <- data[[metr_var_name]]
  dicho <- data[[dicho_var_name]]
  
  # helper: check if metr is numeric
  # helper: check if dicho is dichotomous, check if numeric (0,1), if not: convert?
  
  results <- list(
    twosided <- cor.test(metr, dicho),
    onsided_greater <- cor.test(metr, dicho, alternative = "greater"),
    onsided_less <- cor.test(metr, dicho, alternative = "less")
  )
  
  return(results)
  
}

#Test
cor_metr_dicho(titanic_data, "Age", "Survived")

## Helper functions:
check_if_col_exists <- function(data, var_name) {
  if(!(data[[var_name]] %in% names(data))) stop("Eine der angegebenen Spalten existiert nicht im Datensatz.")
}

check_if_numeric <- function(data, var_name) {
  if(!is.numeric(data[[var_name]])) stop(paste(var_name, "ist nicht numerisch."))
}

check_if_dichotomous <- function(data, var_name) {
  if(length(unique(na_omit(data[[var_name]]))) > 2) stop(paste(var_name, "scheint nicht dichotom zu sein"))
}