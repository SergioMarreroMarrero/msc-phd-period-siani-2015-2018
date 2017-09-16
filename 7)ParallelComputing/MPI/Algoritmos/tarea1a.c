/*Autor: Sergio Marrero*/
/* Programa para repartir los elementos de un vector a distintos procesos usando MPI*/

#include <stdio.h>
#include <stdlib.h>
#include "mpi.h"
#define dimVector 14

int main(int argc, char *argv[]) {

int myrank, nprocs; //  Identificador de procesos y numero total de procesos
int *sendcounts;    // Contiene el numero que se envia a cada proceso
int *displs;	  // Lotes en los que se envia

int vector[dimVector]; // Vector que queremos enviar
int bufreception[dimVector]; // Creamos el buffer de recepcion 
int q,i,source=0,tag=1; // Fuente y tag
MPI_Status Stat;


MPI_Init(NULL, NULL);
MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
MPI_Comm_rank(MPI_COMM_WORLD, &myrank);

/* Inicialización del vector */
if (myrank==0){

	for (i=0; i<dimVector; i++) {
	vector[i] = i;
	printf("  %i ",vector[i]);
	}

printf(" \n\n");
}


sendcounts=malloc(sizeof(int)*nprocs); // Terminamos de crear el vector sendcounts
displs=malloc(sizeof(int)*nprocs); // Terminamos de crear el vector displs

// Calculamos sendcounts y displs
int rem=dimVector%nprocs; // Elementos que sobran 
int sum=0;   // Esta variable calcular los desplazamientos
for (i = 0; i < nprocs; i++) {
    sendcounts[i] = dimVector/nprocs;
     if (rem > 0) {
         sendcounts[i]++;	// Añadimos un elemento 
         rem--; 		// Queda un elemento menos por repartir
     }

     displs[i] = sum; 
     sum += sendcounts[i];
}


// Observamos los resultados obtenidos
if (myrank == source) {
    for (i = 0; i < nprocs; i++) {
        printf("sendcounts[%d] = %d\tdispls[%d] = %d\n", i, sendcounts[i], i, displs[i]);
    }
}

// El Scatter lo tienen que hacer todos
MPI_Scatterv(vector, sendcounts, displs, MPI_INT, bufreception, dimVector, MPI_INT, source, MPI_COMM_WORLD);


//Modulo de lectura de resultados: Todos los procesos le envian el resultado a source, y el lo muestra por pantalla.
if (myrank !=0){
MPI_Send(bufreception, dimVector, MPI_INT, source, tag, MPI_COMM_WORLD);
} else {

	printf("Proceso %d of %d \n", myrank, nprocs);
		for (i=0; i<sendcounts[myrank]; i++) {
		printf("%i\n",bufreception[i]);
		}
		for (q = 1; q < nprocs; q++) {
			MPI_Recv(bufreception,dimVector, MPI_INT, q, tag, MPI_COMM_WORLD, &Stat);
			printf("Processo: %i of %d \n",Stat.MPI_SOURCE,nprocs);
			for (i=0; i<sendcounts[(int) Stat.MPI_SOURCE]; i++) {
				printf("%i\n",bufreception[i]);
			}
		}
	}




MPI_Finalize();

}







