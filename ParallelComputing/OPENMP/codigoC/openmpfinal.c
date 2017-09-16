#include <stdio.h>
#include <stdlib.h>
#include <omp.h> 

/* Programa para multiplicar una matriz b de mxn por un vector c de nx1 - Versión secuencial*/
void mxv(int m, int n, double *a, double *b, double *c);
int main(int argc, char *argv[]) {
double *a, *b, *c;
int i, j, m, n;
double  tiempoInicio, tiempoFinal;
float tiempo, MFlops;

if (argc != 3) {
fprintf(stderr, "Falta algun argumento\n");
exit(EXIT_FAILURE);
}
m = atoi(argv[1]);
n = atoi(argv[2]);

double Nops = 2 * n * n ;

printf("mxv, %i x %i\n", n,m);cd ..

if ((a=(double *)malloc(m*sizeof(double))) == NULL) {
perror("Error al reservar memoria para a");
exit(EXIT_FAILURE);
}
if ((b=(double *)malloc(m*n*sizeof(double))) == NULL) {
perror("Error al reservar memoria para b");
exit(EXIT_FAILURE);
}
if ((c=(double *)malloc(n*sizeof(double))) == NULL) {
perror("Error al reservar memoria para c");
exit(EXIT_FAILURE);
}
/* Inicialización de la matriz b y el vector c */
for (j=0; j<n; j++) c[j] = 2.0;
for (i=0; i<m; i++)
for (j=0; j<n; j++) b[i*n + j] = i;

/* Calculo del producto matriz x vector */
tiempoInicio = omp_get_wtime(); // empieza a contar el tiempo
mxv(m, n, a, b, c);
tiempoFinal = omp_get_wtime(); // termina de contar el tiempo
tiempo = ((float)tiempoFinal - (float)tiempoInicio);
  printf("dgemm_secuencial: %7.1f seg,", tiempo);
  printf(" %7.1f MFlops\n", (tiempo>0?(float)(Nops/(tiempo*1e6)):0));


/* Liberación de la memoria previamente reservada */
free(a), free(b); free(c);
return 0;
}
void
mxv(int m, int n, double *a, double *b, double *c){
int i, j;
for (i=0; i<m; i++) {
a[i] = 0.0;
for (j=0; j<n; j++) a[i] += b[i*n + j]*c[j];
}
}

