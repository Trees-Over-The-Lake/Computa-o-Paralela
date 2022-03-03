/*
   Tempo sequencial:

   real 4.36
   user 4.36
   sys 0.00
   real 4.35
   user 4.35
   sys 0.00
   real 4.36
   user 4.35
   sys 0.00
   real 4.36
   user 4.36
   sys 0.00
   real 6.53
   user 6.52
   sys 0.00
   real 4.36
   user 4.36
   sys 0.00
   real 6.23
   user 6.22
   sys 0.00
   real 6.51
   user 6.50
   sys 0.00
   real 4.39
   user 4.39
   sys 0.00
   real 4.35
   user 4.35
   sys 0.00

   Tempo paralelo sem schedule:

   real 3.31
   user 5.87
   sys 0.00
   real 3.26
   user 5.89
   sys 0.00
   real 3.36
   user 5.98
   sys 0.00
   real 2.63
   user 4.89
   sys 0.00
   real 2.64
   user 4.90
   sys 0.00
   real 2.64
   user 4.89
   sys 0.00
   real 3.11
   user 5.75
   sys 0.00
   real 3.45
   user 6.18
   sys 0.00
   real 2.63
   user 4.88
   sys 0.00
   real 3.32
   user 5.96
   sys 0.00

   Tempo paralelo usando Guided:

   real 2.85
   user 4.89
   sys 0.00
   real 2.64
   user 4.89
   sys 0.00
   real 2.80
   user 5.07
   sys 0.00
   real 2.80
   user 5.57
   sys 0.00
   real 3.89
   user 7.26
   sys 0.00
   real 2.64
   user 4.91
   sys 0.00
   real 2.82
   user 5.08
   sys 0.00
   real 2.63
   user 4.90
   sys 0.00
   real 2.64
   user 4.91
   sys 0.00
   real 2.64
   user 4.90
   sys 0.01
*/

#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main() 
{
   omp_set_num_threads(2);

   int i, j, n = 30000; 

   // Allocate input, output and position arrays
   int *in = (int*) calloc(n, sizeof(int));
   int *pos = (int*) calloc(n, sizeof(int));   
   int *out = (int*) calloc(n, sizeof(int));   

   // Initialize input array in the reverse order
   for(i=0; i < n; i++)
      in[i] = n-i;  

   // Print input array
   //   for(i=0; i < n; i++) 
   //      printf("%d ",in[i]);
    
   // Silly sort (you have to make this code parallel)
   #pragma omp parallel for schedule(static, 100)
   for(i=0; i < n; i++) 
      #pragma omp parallel for schedule(static, 100)
      for(j=0; j < n; j++)
	     if(in[i] > in[j]) 
            pos[i]++;	

   // Move elements to final position
   for(i=0; i < n; i++) 
      out[pos[i]] = in[i];
   
   // print output array
   //   for(i=0; i < n; i++) 
   //      printf("%d ",out[i]);

   // Check if answer is correct
   #pragma omp parallel for
   for(i=0; i < n; i++)
      if(i+1 != out[i]) 
      {
         printf("test failed\n");
         exit(0);
      }

   printf("test passed\n"); 
}  
