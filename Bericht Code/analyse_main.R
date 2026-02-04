#Analyse für den Bericht 

#Setup 
titanic.data <- read.csv("titanic_clean.csv")
source("Funktionen-R-Skript-1-Modified.R")

#Wir refactorieren  nochmals einige Daten damit wir später keine Wichtigen 
#Punkte in den Funktionen verlieren

titanic.data$Survived <- as.factor(titanic.data$Survived) 
titanic.data$Pclass <- as.factor(titanic.data$Pclass)
titanic.data$Sex <- as.factor(titanic.data$Sex)
titanic.data$Embarked <- as.factor(titanic.data$Embarked)



#Wir nutzen die Funktionen um einen Überblick zu bekommen und um Hypothesen zu
#testen

#Wir verwenden zuerst Funktion 1 um eine Sache bei den Ticketpreisen zu untersuchen

metric.data <- berechne_metrische_statistiken(titanic.data = titanic.data)

print(metric.data)

#Man kann erkennen das es einen Starken unterschied bei
#dem Median und dem Arithmetischen Mittel gab bei den Preisen das lässt hindeuten auf eine
#Gruppen von sehr wohlhabenden an Board, ob diese bei der Rettung bevorzugt wurden testen wir später
#Alter des Durchschnittspassagiers: 30 Jahre 

#Wir gucken uns an wer auf dem Schiff war 

kategorial.data <- berechne_kategoriale_statistiken(titanic.data = titanic.data)

print(kategorial.data)

#Was wir hier Rauslesen: 64,76 % der Menschen an Board waren Männlich 
#Die Meisten kamen aus Southhampton mit 72.5%
#Der Großteil der Menschen ist gestorben mit einem Anteil von 61.62% 
#Die Meisten an Board gehörten der Preisklasse 3 an also dem niedrigkostensegment

#Jetzt testen wir ein paar Hypothesen 
#Die Vermutung ist das die Entscheidung wer auf ein Rettungsbot kommt nach dem verfahren,
#"Frauen und Kinder zuerst" gewählt wurde, wäre da etwas dran  müssten 
#die Merkmale Sex und Survived zusammenhängen

Cor.data.sex <- analyze_categorical_relation(titanic.data, "Sex", "Survived")
