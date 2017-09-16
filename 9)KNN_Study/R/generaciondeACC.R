# Este script genera dos archivos llamados resultsEuclidea.csv y
# resultsManhattan.csv y tablaAccuracyknn20rep.csv Estos archivos contendran los resultados 
#de los experimentos.

ionosphera<-read.csv(file = "/home/sergio/MEGAsync/Trabajosfinales/I+D/PracticaFinal/data/ionosphera.csv",header = TRUE, sep=",")
library(graphics)
library(knnGarden) # Liberería para usar vecinos mas cercanos
library(rminer) # Librería para hacer hold out
main<-"/home/sergio/MEGAsync/Trabajosfinales/I+D/PracticaFinal/data/resultados"


# Creamos funcion que nos devuelva el ACC 
accuracyKnn <- function(ionosphera,seed,vecinos,p){
  
  H=holdout(ionosphera$Class,ratio=3/5,internal=TRUE,mode="stratified",seed=seed)
  trainIonosphera<-ionosphera[H$tr,1:34 ]
  classTrainingIonos<-ionosphera[H$tr,35 ]
  testIonosphera<-ionosphera[H$ts,1:34 ]
  clasificacionIonosphera<-knnVCN(TrnX=trainIonosphera, OrigTrnG=classTrainingIonos,TstX= testIonosphera, K=vecinos, ShowObs = FALSE, method = "minkowski", p=p)
  clasiytest<-data.frame(ionosphera[H$ts,35 ],clasificacionIonosphera)
  names(clasiytest)<-c("test","clasificados")
  accuracy<-sum(clasiytest$test==clasiytest$clas)/nrow(clasiytest)
  return(accuracy)
}


# Este algoritmo usa la funcion de arriba. Genera las tablas con el resultado
# de los experimentos

for (factorDistancia in c(1,2)) {
  results<-data.frame()
  ifelse(factorDistancia==1,name<-"Manhattan",name<-"Euclidea")
  savepath<-paste(main,name,".csv",sep="")
  contvecinos<-0
  for (vecinos in seq(1,20, by = 2)) {
    contvecinos<-contvecinos+1
    seed<-1234
    for (replica in seq(1,20, by = 1)){
      seed<-seed+10
      results[replica,contvecinos]<-accuracyKnn(ionosphera,seed,vecinos,factorDistancia)
    }
  }
  #Guardamos resultados
  #colnames(results)<-c("k1","k2","k3","k4","k5","k6","k7","k8","k9","k10")
  colnames(results)<-c("k1","k3","k5","k7","k9","k11","k13","k15","k17","k19")
  write.csv(results,file=savepath,row.names = FALSE) # Guardamos los resultados
  remove(results)
}


## A continuacion se hacer una pequeña rutina para
# para colocar los resultados en un solo archivo de tres
# columnas

resultados<-append(resultadosEuclidea$k1,resultadosEuclidea$k3)
for (i in seq(3,10, by=1)) {
  resultados<-append(resultados,resultadosEuclidea[ ,i])
}
#
factorDistancia<-rep("Euclidea",200)
#
factorVecino<-rep(1,20)
for (i in seq(2,10, by=1)) {
  factorVecino<-append(factorVecino,rep(i,20))
}

# Manhattan
for (i in seq(1,10, by=1)) {
  resultados<-append(resultados,resultadosManhattan[ ,i])
}
#
factorDistancia<-append(factorDistancia,rep("Manhattan",200))
#
factorVecino<-append(factorVecino,factorVecino)

tablaAccuracyknn20rep<-data.frame(resultados,factorVecino,factorDistancia)
savepath<-paste(main,"All.csv",sep="")
write.csv(tablaAccuracyknn20rep,file=savepath,row.names = FALSE) # Guardamos los resultados






