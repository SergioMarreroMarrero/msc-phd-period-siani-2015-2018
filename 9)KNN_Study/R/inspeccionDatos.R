#Este archivo se uso para inspeccionar los datos y
# hacer algunas pruebas

ionosphera<-read.csv(file = "/home/sergio/MEGAsync/Trabajosfinales/I+D/PracticaFinal/data/ionosphera.csv",header = TRUE, sep=",")
library(graphics)
library(xtable) # Nos permite pasar tablas a latex


############################## 1) Inspeccion de la base de datos ########################################
# Escogemos una muestra para observar los datos y la pasamos a latex
ionospherahead<-head(ionosphera,6)
ionospheraheadparcial<-ionospherahead[ ,c(1,2,3,4,33,34,35)]
print(xtable(ionospherahead), include.rownames = TRUE) # Imprimios en pantalla la tabla para latex

############################## Ploteamos la parte real y la parte imaginaria ##########################################
# Separamos los subconjuntos para plotear
ionospheraheadReal<-ionospherahead[ ,seq(1,33, by=2)]
ionospheraheadImag<-ionospherahead[ ,seq(2,34, by=2)]
## Ploteamos
fila=4 # Con este parametro elegimos la fila que queremos plotear
par(mfrow=c(2,2))
plot(1:17,ionospheraheadReal[fila,1:17],"o",col="red"
     ,xlim=c(1,17),ylim=c(-1,1)
     ,xlab = "Time lag",ylab= "Normalized power"
     ,sub=x <- ifelse(ionosphera[fila,35]=="g", "Clase=Good", "Clase=Bad")
     ,axes=T)
lines(1:17,ionospheraheadImag[fila,1:17],"o",col="blue")
dev.off()# Elimina la ventana grafica actual