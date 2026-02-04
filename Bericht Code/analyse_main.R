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

#Was wir hier Auslesen: 64,76 % der Menschen an Board waren Männlich 
#Die Meisten kamen aus Southampton mit 72.5%
#Der Großteil der Menschen ist gestorben mit einem Anteil von 61.62% 
#Die Meisten an Board gehörten der Preisklasse 3 an also dem niedrigsten

#Jetzt testen wir ein paar Hypothesen 
#Die Vermutung ist das die Entscheidung wer auf ein Rettungsbot kommt nach dem verfahren,
#"Frauen und Kinder zuerst" gewählt wurde, wäre da etwas dran  müssten 
#die Merkmale Sex und Survived zusammenhängen

Cor.data.sex <- analyze_categorical_relation(titanic.data, "Sex", "Survived")

print(Cor.data.sex$plot.data)

#Hier können wir schon einige Beobachtungen machen bei Frauen wurden Prozentual gesehen
#74.2% gerettet während bei den Männern es nur 18.89% überlebt haben. Lässt darauf schließen 
#das die Hypothese korrekt war 

#Jetzt Testen wir noch ob die Preisklasse in der man war einen unterschied machte 

cor.data.pclass <- analyze_categorical_relation(titanic.data, "Pclass", "Survived")

print(cor.data.pclass$plot.data)

#Auch hier lassen sich wieder zusammenhänge finden in der Preisklasse 3 sind 75.76%
#der Menschen gestorben während es in Preisklasse 2 nur noch 52.71% waren und in Klasse 1 
# 37.037% zeigt das da wahrscheinlich ein Zusammenhang war 


#Jetzt überprüfen wir etwas genauer, Preisklassen sind grobe richtungen, wir wollen schauen ob
#der Ticketpreis direkt mit der Überlebenschance korrelierte 

dicho.data.pclass <- cor_metr_dicho(titanic.data, "Fare", "Survived")

print(dicho.data.pclass)

#Die Korrelation liegt bei 0.257 und significance = "Ja" damit können wir sagen 
#das die Preisklasse auf jeden Fall einen Zusammenhang mit der Überlebenschance hatte

#Wir überprüfen auch noch ob das Alter eine Rolle spielte bei solchen dingen
dicho.data.age <- cor_metr_dicho(titanic.data, "Age", "Survived")

print(dicho.data.age)

#Wir haben hier eine leicht negative Korrelation -0,089 daraus lässt sich deuten 
#das eher Jüngere Personen das ganze Überlebt haben ob das daran liegt das Jüngere
#Personen einfach länger durchgehalten haben wegen ihrer vitatlität oder ob sie
#bevorzugt wurden lässt sich nicht konkret sagen

#Wir verwenden Funktion 5 um einen Übersichtsplot über die Ereignesse zu Zeigen, 
#Wie genau waren die Personengruppen die wir untersuchten verteilt und was genau haben sie gemacht 

facet.plot.data <- v.visualiasation(titanic.data, "Survived", "Sex", "Pclass")

print(facet.plot.data)

#Teil 2 - Erstellung visueller Plots für den Bericht
#Wir wollen unsere Aussagen jetzt gut darstellbar machen für diese Abgabe

#1.Plot untersuchung des Einflusses von Geschlecht auf die Überlebenschancen

plot.sex <-  ggplot(Cor.data.sex$plot.data, aes(x = Gruppe, y = Prozent, fill = Status)) +
  
  #Wir erstellen unseren Barplot durch fill wird er immer 100% sein 
  geom_bar(stat = "identity", position = "fill") +
  
  #Wir passen die y-Achse an um Prozente darzustellen
  scale_y_continuous(labels = scales::percent) +
  
  #Wir nehmen unsere Farbpallete
  scale_fill_viridis_d(option = "mako", begin = 0.3, end = 0.8, name = "Status") +
  
  #Fügen noch Achsenbeschriftungen hinzu
  labs(title = "Überlebenschance nach Geschlecht",
       x = "Geschlecht",
       y = "Anteil") +
  
  #Und wählen unser Theme
  theme_minimal(base_size = 12)


print(plot.sex)












