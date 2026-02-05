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
#Und wie viele von ihnen gestorben sind oder überlebt haben 

facet.plot.data <- v.visualiasation(titanic.data, c("Survived", "Sex", "Pclass"))

print(facet.plot.data)

ggsave("Plot0.png", plot = facet.plot.data, width = 10, height = 4.5, dpi = 300)

#Teil 2 - Erstellung visueller Plots für den Bericht
#Wir wollen unsere Aussagen jetzt gut darstellbar machen für diese Abgabe

#Plot 1 - Zusammenhang zwischen Ticketpreisen und Überlebenschance


#Wir bennen Survial noch um damit es im Plot richtig steht 
plot.1.data <- titanic.data %>%
  #
  mutate(
    Survived = factor(Survived, levels = c(0, 1), labels = c("Verstorben", "Überlebt"))
  ) 
  
#Wir erstellen unseren Plot mit ggplot
plot.fare <- ggplot(plot.1.data, aes(x = as.factor(Survived), y = Fare, fill = as.factor(Survived))) +
  
  #Wir nehmen einen Boxplot um eine gute Übersicht über die Verteilung der Ticketpreise zu bekommen
  geom_boxplot(outlier.shape = 2, apha = 0.9) + #Ausreißer werden damit als Kreise dargestellt 
  
  scale_y_log10() + #Logarithmische Skala wegen der extremen Differenzen der Preise  
  
  #Wir erstellen die Achsenbeschriftung sowie unsere Standard Farbpallete 
  scale_fill_viridis_d(option = "mako", begin = 0.4, end = 0.8) +
  
  labs(title = "Verteilung der Ticketpreise nach Überleben",
       x = "Status",
       y = "Ticketpreis (Logarithmisch)") +
  
  theme_minimal()

#Wir geben unseren plot aus 

print(plot.fare)

ggsave("Plot1.png", plot = plot.fare, width = 10, height = 4.5, dpi = 300)

#Plot 2 - Zusammenhang zwischen Familiengröße und Überlebenschance 

#Wir rechnen geschwister eheparter und Kinder zusammen für eine Familiengröße
titanic.data$FamilySize <- titanic.data$SibSp + titanic.data$Parch + 1

#Alle Familien >= 5 gruppieren wir zu einem Im plot für Übersichtlichkeit
titanic.data$FamilyGroup <- ifelse(titanic.data$FamilySize >= 5, "5+", titanic.data$FamilySize)

#Wir ändern wieder die labels für verstorben und Überlebt 
plot.4.data <- titanic.data %>%
  
  mutate(
    Survived = factor(Survived, levels = c(0, 1), labels = c("Verstorben", "Überlebt"))
  ) 

#Wir erstellen wieder unseren ggplot 
plot.famsize <- ggplot(plot.4.data, aes(x = FamilyGroup, fill = Survived)) +
  
  #Wir erstellen unser Balken diagramm mit "stack" für die absoluten Häufigkeiten
  geom_bar(position = "stack", alpha = 0.9) +
  
  #Wieder unsere Achsenbeschriftung und Typische Farbpalette
  scale_fill_viridis_d(option = "mako", begin = 0.3, end = 0.8, name = "Status") +
  
  labs(title = "Überlebenschance nach Familiengröße",
       x = "Anzahl der Familienmitglieder",
       y = "Überlebendenanteil") +
  
  theme_minimal(base_size = 12)

#Wir geben unseren Plot aus 
print(plot.famsize)

ggsave("Plot2.png", plot = plot.famsize, width = 10, height = 4.5, dpi = 300)

#Plot 3 - Density Plot - Übrelebende vs. Tote Altersverteilung 

#Wir modifiziren wieder die Plot namen für die Achsenbeschriftung 
plot.3.data <- titanic.data %>%
  mutate(
    Survived = factor(Survived, levels = c(0, 1), labels = c("Verstorben", "Überlebt"))
  )

#Wir erstellen unseren Denstiy Plot
plot3 <- ggplot(plot.3.data, aes(x = Age, fill = Survived, color = Survived)) +
  
  #Densityplot
  geom_density(alpha = 0.7) +
  
  #Wir zeichnen die Line wo age 0 18 ist damit man den Unterschied zwischen Kindern und Erwachsenen besser sehen kann
  geom_vline(xintercept = 18, linetype = "dashed", color = "black") +
  
  #Wir nehmen wieder unsere Farbpalette 
  scale_fill_viridis_d(option = "mako", begin = 0.3, end = 0.8) +
  
  scale_color_viridis_d(option = "mako", begin = 0.3, end = 0.8) +
  
  #Wir fügen noch ein paar Theme Optionen für die Schönheit hinzu
  theme_minimal(base_size = 12) +
  
  theme(
    legend.position = "right"
  ) +
  labs(
    title = "Verteilung des Alters bei Überlebenden versus Verstorbenen",
    x = "Alter",
    y = "Dichte (rel. Hauefigkeit)"
  )

ggsave("Plot3.png", plot = plot3, width = 10, height = 4.5, dpi = 300)