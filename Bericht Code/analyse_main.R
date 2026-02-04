#Analyse für den Bericht 

#Setup 
titanic.data <- read.csv("titanic_clean.csv")
source("Funktionen-R-Skript 1.R")


#Wir testen erstmal die Funktionen um herauszufinden wie wir sie vernünftig 
#einbauen können: 

#i)
metric.data <- berechne_metrische_statistiken(titanic.data = titanic.data)

#ii)

kat.data <-  berechne_kategoriale_statistiken(titanic.data = titanic.data)

#iii)

sex.survive.rel.data <- analyze_categorical_relation(titanic.data, "Sex", "Survived")

#iv) 

cor.data <- cor_metr_dicho(titanic.data, "Fare", "Survived")

#v) 

plot.test <- v.visualisation(titanic.data, "Sex", "Survived", "Title")

print(metric.data)
print(kat.data)
print(sex.survive.rel.data)
print(cor.data)
print(plot.test)
