#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

void mm(double* a, double* b, double* c, int width) 
{
    #pragma omp target map(tofrom: a[0:width], b[0:width], c[0:width])
    #pragma omp teams distribute parallel for
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < width; j++) {
      
            double sum = 0;
      
            #pragma omp parallel for simd reduction(+: sum)
            for (int k = 0; k < width; k++) {
                double x = a[i * width + k];
                double y = b[k * width + j];
                sum += x * y;
            }

      c[i * width + j] = sum;
    }
  }
}

int main()
{
  int width = 2000;
  double *a = (double*) malloc (width * width * sizeof(double));
  double *b = (double*) malloc (width * width * sizeof(double));
  double *c = (double*) malloc (width * width * sizeof(double));

  #pragma omp target map(tofrom: a[0:width],b[0:width],c[0:width])
  #pragma omp teams distribute parallel for simd
  for(int i = 0; i < width; i++) {
    for(int j = 0; j < width; j++) {
      a[i*width+j] = i;
      b[i*width+j] = j;
      c[i*width+j] = 0;
    }
  }
  
  mm(a,b,c,width);
    for(int i = 0; i < width; i++) {
        for(int j = 0; j < width; j++) {
        printf("\n c[%d][%d] = %f",i,j,c[i*width+j]);
        }
    }
}