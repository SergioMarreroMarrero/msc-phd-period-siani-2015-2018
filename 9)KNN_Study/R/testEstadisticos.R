# En este archivo se llevan a cabo los test estadisticos
##################Tratamiento estadistico ######################################
tablaAccuracyknn20rep<-read.csv(file = "/home/sergio/MEGAsync/Trabajosfinales/I+D/PracticaFinal/data/resultadosAll.csv",header = TRUE, sep=",")
resultadosEuclidea<-read.csv(file = "/home/sergio/MEGAsync/Trabajosfinales/I+D/PracticaFinal/data/resultadosEuclidea.csv",header = TRUE, sep=",")
resultadosManhattan<-read.csv(file = "/home/sergio/MEGAsync/Trabajosfinales/I+D/PracticaFinal/data/resultadosManhattan.csv",header = TRUE, sep=",")
#Cajas y dispersion de distancias
boxplot(resultados~factorDistancia,data = tablaAccuracyknn20rep,
        xlab="Factor distancia",ylab="Accuracy",outline=TRUE,ylim=c(0.7,1),col =c("red","green"))


#Cajas y dispersion segun vecinos. Separando la clase
color<-c("blue","red","green","antiquewhite","orange","yellow","darkorchid2","deeppink2","darkslategray1","darkred")
boxplot(resultados~factorVecino,data = tablaAccuracyknn20rep,
        xlab="Factor vecinos",ylab="Accuracy",outline=FALSE,ylim=c(0.7,1),
        col =color)


#Cajas y dispersion de los distintos tratamientos
col<-c(rep("red",10),rep("green",10))
boxplot(resultados~factorVecino*factorDistancia,data = tablaAccuracyknn20rep,
        xlab="Tratamientos",ylab="Accuracy",outline=TRUE,ylim=c(0.7,1),col =col)

################################## Test de normalidad #########################
library("moments")
# Euclideo
jarque.test(resultadosEuclidea$k1)
jarque.test(resultadosEuclidea$k3)
jarque.test(resultadosEuclidea$k5)
jarque.test(resultadosEuclidea$k7)
jarque.test(resultadosEuclidea$k9)
jarque.test(resultadosEuclidea$k11)
jarque.test(resultadosEuclidea$k13)
jarque.test(resultadosEuclidea$k15)
jarque.test(resultadosEuclidea$k17)
jarque.test(resultadosEuclidea$k19)

#Manhatan
jarque.test(resultadosManhattan$k1)
jarque.test(resultadosManhattan$k3)
jarque.test(resultadosManhattan$k5)
jarque.test(resultadosManhattan$k7)
jarque.test(resultadosManhattan$k9)
jarque.test(resultadosManhattan$k11)
jarque.test(resultadosManhattan$k13)
jarque.test(resultadosManhattan$k15)
jarque.test(resultadosManhattan$k17)
jarque.test(resultadosManhattan$k19)


###################################### ANOVA #############################
#Calculamos la ANOVA de dos factores
tablaAnova<-aov(resultados ~ factorVecino*factorDistancia,data = tablaAccuracyknn20rep)
sumarytablaAnova<-summary(tablaAnova)
print(xtable(sumarytablaAnova), include.rownames = TRUE) 

#Test de Friedman
tablaFriedman<-friedman.test(resultados ~ factorVecino*factorDistancia,data = tablaAccuracyknn20rep)
sumarytablaAnova<-summary(tablaAnova)
print(xtable(sumarytablaAnova), include.rownames = TRUE) 


## Dibujamos histograma y funcion de densidad estimada
barras=10 # Elegir el numero de barras
par(mfrow=c(2,1))
hist(resultadosEuclidea$k15,col="red",xlab="ACC",ylab="Frecuenccia",main="",breaks =barras,freq=FALSE)
lines(density(resultadosEuclidea$k15))
hist(resultadosManhattan$k1,col="blue",xlab="Accuracy",ylab="Frecuency", main="Distribucion de la ACC ",breaks =barras,freq=FALSE)
lines(density(resultadosManhattan$k1))

# Test de student
t.test(resultadosEuclidea$k1,resultadosManhattan$k1)
