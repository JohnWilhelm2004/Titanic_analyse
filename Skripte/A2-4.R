## Aufgabe 2
## iv)

titanic_data <- read.csv("titanic_clean.csv")

# Aufgabenstellung: Eine Funktion, die geeignete deskriptive bivariate Statistiken für den
# Zusammengang zwischen einer metrischen und einer dichotomen
# Variablen berechnet und ausgibt.
# -> Punktbiseriale Korrelation (r_pb)

## Helper functions:
check_if_col_exists <- function(data, var_name) {
  if(!(var_name %in% names(data))) stop("Eine der angegebenen Spalten existiert nicht im Datensatz.")
}

check_if_numeric <- function(data, var_name) {
  if(!is.numeric(data[[var_name]])) stop(paste(var_name, "ist nicht numerisch."))
}

check_if_dichotomous <- function(data, var_name) {
  if(length(unique(na.omit(data[[var_name]]))) > 2) stop(paste(var_name, "ist nicht dichotom"))
}

# Falls der Vektor der dichotmen Variable nicht numerisch ist, wird er umgewandelt
get_dichotomous_vals = function(data, var_name) {
  if(!is.numeric(data[[var_name]])) {
    new_vec <- (as.numeric(as.factor(data[[var_name]]))) - 1
    message(paste("Info: Spalte", var_name, "wurde für die Korrelation in Zahlen(0/1) umgewandelt."))
  } else {
    new_vec = data[[var_name]]
  }
  return(new_vec)
}



# Function:
cor_metr_dicho <- function(data, metr_var_name, dicho_var_name) {
  # helper functions:
  check_if_col_exists(data, metr_var_name)
  check_if_col_exists(data, dicho_var_name)
  
  check_if_numeric(data, metr_var_name)
  check_if_dichotomous(data, dicho_var_name)
  
  # Daten extrahieren:
  metr <- data[[metr_var_name]]
  dicho <- get_dichotomous_vals(data, dicho_var_name) # anstelle von data[[dicho_var_name]]
  
  results <- list(
    twosided = cor.test(metr, dicho),
    onsided_greater = cor.test(metr, dicho, alternative = "greater"),
    onsided_less = cor.test(metr, dicho, alternative = "less")
  )
  
  return(results)
  
}

#Test
cor_metr_dicho(titanic_data, "Age", "Survived")

cor_metr_dicho(titanic_data, "Age", "Sex")


