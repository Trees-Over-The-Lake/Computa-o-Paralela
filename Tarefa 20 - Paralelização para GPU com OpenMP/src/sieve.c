/*
* Adapted from: http://w...content-available-to-author-only...s.org/sieve-of-eratosthenes

   Aluno: Lucas Santiago de Oliveira
   Matrícula: 650888

   Meu computador:
   Ryzen 5 3600XT
   16GB RAM 2400mhz
   GTX 1060 3GB

   Tempo paralelo no meu computador
   real 0.98
   user 3.87
   sys 1.43

   Tempo sequencial no meu computador
   real 1.00
   user 0.98
   sys 0.01
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <omp.h>

int sieveOfEratosthenes(int n) {
   // Create a boolean array "prime[0..n]" and initialize
   // all entries it as true. A value in prime[i] will
   // finally be false if i is Not a prime, else true.
   int primes = 0; 
   bool *prime = (bool*) malloc((n+1)*sizeof(bool));
   int sqrt_n = sqrt(n);

   memset(prime, true,(n+1)*sizeof(bool));

   #pragma omp parallel for
   for (int p=2; p <= sqrt_n; p++)
   {
      // If prime[p] is not changed, then it is a prime
      if (prime[p] == true)
      {
         // Update all multiples of p
         #pragma omp target map(tofrom: prime)
         #pragma omp teams distribute parallel for simd
         for (int i=p*2; i<=n; i += p)
            prime[i] = false;
      }
   }


   // count prime numbers
   #pragma omp parallel for simd reduction(+: primes)
   for (int p=2; p<=n; p++)
      if (prime[p])
         primes++;

   return(primes);
}

int main()
{
   //omp_set_nested(1);
   int n = 100000000;
   printf("%d\n",sieveOfEratosthenes(n));
   return 0;
} 
