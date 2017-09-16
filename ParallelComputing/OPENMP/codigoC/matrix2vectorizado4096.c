//
// dgemm_serial_ss.c
//
// Ejercicio 1 - Multiplicacion de matrices: C = B x A, versi�n no paralela
// Compilaci�n: gcc -o dgemm_serial_ss dgemm_serial_ss.c -O2
//
#include <stdio.h>
#include <time.h>
#include <xmmintrin.h>

#define Nmatriz 4096
#define Nmax (Nmatriz * Nmatriz)

float a[(int)Nmax], b[(int)Nmax], c[(int)Nmax];

void inicializa(){
  int i;
  // Inicializa el generador de numeros aleatorios
  time_t semilla = (long int) 223456;  
  srand48((long int)semilla);// plantamos la semilla
  for(i = 0; i < Nmax; i++){ // inicializamos los vectores: a,b,c
        a[i] = (float) i; //lrand48(); // cuando se compruebe la funcionalidad correcta de la multiplicaci�n, cambiar a aleatorio
        b[i] = a[i];
        c[i] = 0;
  }
}

void dgemm (int n, float* A, float* B, float* C)
{
 int i,j,k;
 for (i = 0; i < n; i+=4)
   for (j = 0; j < n; ++j)
   {
	__m128 c0=_mm_load_ps(C+i+j*n);
    float cij = C[i+j*n]; /* cij = C[i][j] */
    for(k = 0; k < n; k++ )
     c0 = _mm_add_ps(c0, /* c0 += A[i][k]*B[k][j] */
	_mm_mul_ps(_mm_load_ps(A+i+k*n),
	_mm_load_ps1(B+k+j*n) ));
_mm_store_ps(C+i+j*n, c0); /* C[i][j] = c0 */

   }
}

main(){

  clock_t tiempoInicio, tiempoFinal;
  float tiempo, MFlops;
  int i,j;
// Operaciones en mutiplicacion de 2 matrices: mult= n x n x n; sumas "+=" = n x n x n
  double dNmatriz = (double) Nmatriz;
  double Nops = 2 * dNmatriz * dNmatriz * dNmatriz;

  tiempoInicio = clock(); // empieza a contar el tiempo

  inicializa();

  tiempoFinal = clock(); // termina de contar el tiempo
  
  tiempo = ((float)tiempoFinal - (float)tiempoInicio) / (float)CLOCKS_PER_SEC;
  printf("inicializa una matriz de %i x %i floats: %7.1f seg\n", Nmatriz, Nmatriz, tiempo);

  tiempoInicio = clock(); // empieza a contar el tiempo

  dgemm (Nmatriz, a, b, c);

  tiempoFinal = clock(); // termina de contar el tiempo

  tiempo = ((float)tiempoFinal - (float)tiempoInicio) / (float)CLOCKS_PER_SEC;
  printf("dgemm_secuencial: %7.1f seg,", tiempo);
  printf(" %7.1f MFlops\n", (tiempo>0?(float)(Nops/(tiempo*1e6)):0));
}
