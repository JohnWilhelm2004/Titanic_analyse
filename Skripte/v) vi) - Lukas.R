#Aufgabe 2 a) Punkt v) und vi) - Lukas Koenig

#Setup
titanic.data <- read.csv("titanic_clean.csv")
library(tidyverse)

#v) 
v.visualiation <- function(dataset = titanic.data, var1, var2, var3, var4 = NULL){
  #Wir speichern unsere Variablen in einem Vektor 
  var.vec <- c(var1, var2, var3, var4)
  
  #Wir speichern die länge für die Indizierung 
  var.amount <- length(var.vec)
  
  #Wir erstellen einen Data Frame an dem wir unsere Daten später anbinden können
  final.data <- data.frame()
  
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
  #Wir Indizieren über die ganzen Kategoriellen Merkmale und transformieren sie 1 nach dem anderen
  for(i in 1:var.amount){
    #Wir nutzen Rbind um die Sachen unserem Data Frame hinzuzufügen und rufen dann die Hilfsfunktion
    #aus welche unsere Häufigkeiten zu einem Data Frame zusammenfügt 
    final.data <- rbind(final.data, data.transform(var.vec[i]))
  }
  
  #Jetzt erstellen wir mit ggplot den Finalen schritt
  ggplot(final.data, aes(x = var.string, y = abs.prob, fill = var)) +
    
    geom_bar(stat = "identity") +
    
    facet_wrap(~var, scales = "free_x") +
    
    scale_fill_viridis_d(option = "mako", begin = 0.3, end = 0.8) +
    
    theme_minimal() +
    
    theme(
      legend.position = "right",
      strip.text = element_blank()
    ) +
    labs(title = "Absolute Häufigkeiten der Kategorialen Merkmale",
         x = "Merkmale",
         y = "Absolute Häufigkeit")
}

# Testaufruf (Beispiel):
v.visualiation(titanic.data, "Sex", "Pclass", "Embarked")

