/*
* Adapted from: http://w...content-available-to-author-only...s.org/sieve-of-eratosthenes

   Aluno: Lucas Santiago de Oliveira
   Matrícula: 650888

   Tempo sequêncial:
   real 4.76
   user 4.67
   sys 0.07

   real 4.05
   user 3.97
   sys 0.07

   real 4.04
   user 3.97
   sys 0.05

   real 4.39
   user 4.31
   sys 0.06

   real 4.73
   user 4.65
   sys 0.06

   real 4.77
   user 4.67
   sys 0.08

   real 4.73
   user 4.63
   sys 0.08

   real 4.05
   user 3.96
   sys 0.07

   real 4.76
   user 4.67
   sys 0.08

   Tempo paralelo:
   real 3.25
   user 9.16
   sys 0.61

   real 3.30
   user 9.25
   sys 0.63

   real 3.28
   user 9.07
   sys 0.68

   real 3.35
   user 9.12
   sys 0.61

   real 3.47
   user 9.16
   sys 0.69

   real 3.33
   user 9.08
   sys 0.65

   real 3.29
   user 9.14
   sys 0.63

   real 3.31
   user 9.03
   sys 0.66

   real 3.33
   user 9.11
   sys 0.69

   real 3.34
   user 9.15
   sys 0.66

   real 3.31
   user 9.17
   sys 0.66
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
         #pragma omp parallel for simd
         for (int i=p*2; i<=n; i += p)
            prime[i] = false;
      }
   }

   // count prime numbers
   #pragma omp parallel for reduction(+: primes)
   for (int p=2; p<=n; p++)
      if (prime[p])
         primes++;

   return(primes);
}

int main()
{
   omp_set_nested(1);
   int n = 100000000;
   printf("%d\n",sieveOfEratosthenes(n));
   return 0;
} 
