/*Autor: Sergio Marrero*/
/* Programa para realizar el producto escalar entre dos vectores usando MPI*/
#include <stdio.h>
#include <stdlib.h>
#include "mpi.h"
#define dimVector 10000



int main(int argc, char *argv[]) {

int myrank, nprocs; //  Identificador de procesos y numero total de procesos
int *sendcounts;    // Contiene el numero que se envia a cada proceso
int *displs;	  // Lotes en los que se envia

int vector[dimVector],vector2[dimVector]; // Vectores que queremos enviar para multiplicar en distintos procesos
int bufreception[dimVector],bufreception2[dimVector]; // Creamos el buffer de recepcion 
int q,i,source=0,tag=1; // Fuente y tag

double Inicio, Fin; // Variables para medir el tiempo


/*Variables relacionadas con el producto escalar*/
unsigned long mult=0;
int k=10;
unsigned long dotfinal;
unsigned long dotreceive;

MPI_Status Stat; 



MPI_Init(NULL, NULL);
MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
MPI_Comm_rank(MPI_COMM_WORLD, &myrank);

/* Inicialización de los vectores */
if (myrank==0){

for (i=0; i<dimVector; i++) {
	vector[i] = i;
	vector2[i] = 5*i;
	/*printf("  %i , %i",vector[i],vector2[i]);*/
	}
printf(" \n\n");
}





sendcounts=malloc(sizeof(int)*nprocs); // Terminamos de crear el vector sendcounts
displs=malloc(sizeof(int)*nprocs); // Terminamos de crear el vector displs



// Calculamos sendcounts y displs
int sum=0;
int rem=dimVector%nprocs; // Resto 
for (i = 0; i < nprocs; i++) {
    sendcounts[i] = dimVector/nprocs;
     if (rem > 0) {
         sendcounts[i]++;
         rem--;
     }

     displs[i] = sum; 
     sum += sendcounts[i];
}


if (myrank==source){
	Inicio = MPI_Wtime(); // Comienza la cuenta en el proceso: source
}

// Enviamos los elementos a los distintos hilos
MPI_Scatterv(vector, sendcounts, displs, MPI_INT, bufreception, dimVector, MPI_INT, source, MPI_COMM_WORLD);
MPI_Scatterv(vector2, sendcounts, displs, MPI_INT, bufreception2, dimVector, MPI_INT, source, MPI_COMM_WORLD);

//Multiplicacion: Realizamos el producto escalar.

for (i=0; i<sendcounts[myrank];i++) {
mult+=bufreception[i]*bufreception2[i];
}


// Sumamos los resultados obtenidos en cada proceso.
MPI_Reduce(&mult, &dotreceive, 1, MPI_UNSIGNED_LONG, MPI_SUM, source, MPI_COMM_WORLD);



if (myrank==0){
dotfinal=k*dotreceive; //Multiplicamos por un escalar
Fin = MPI_Wtime(); // Finaliza la cuenta

// Imprimimos resultados
printf("\n\nEl producto escalar es: %lu\n\n",dotfinal);
printf("\n\nTiempo de las operaciones: %10.8f milesismas de segundo\n\n ",(Fin-Inicio)*1000);
}

MPI_Finalize();

}







