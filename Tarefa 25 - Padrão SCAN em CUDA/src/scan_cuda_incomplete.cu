#include <stdio.h>
#include <stdlib.h>

__global__ void scan_cuda(double* a, double *s, int width) {
  // kernel scan
} 

__global__ void add_cuda(double *a, double *s, int width) {
  // kernel soma
}

int main()
{
  int width = 40000000;
  int size = width * sizeof(double);

  int block_size = 1024;
  int num_blocks = (width-1)/block_size+1;
  int s_size = (num_blocks * sizeof(double));  
 
  double *a = (double*) malloc (size);
  double *s = (double*) malloc (s_size);

  for(int i = 0; i < width; i++)
    a[i] = i;

  double *d_a, *d_s;

  // alocar vetores "a" e "s" no device
  cudaMalloc((void **), &d_a, size);
  cudaMalloc((void **), &d_s, size);

  // copiar vetor "a" para o device
  cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_s, s, size, cudaMemcpyHostToDevice);

  // definição do número de blocos e threads (dimGrid e dimBlock)

  // chamada do kernel scan
  scan_cuda<<<block_size, num_blocks>>>(a, s, width);

  // copiar vetor "s" para o host
  cudaMemcpy(s, d_s, size, cudaMemcpyDeviceToHost);

  // scan no host (já implementado)
  s[0] = 0;
  for (int i = 1; i < num_blocks; i++)
    s[i] += s[i-1];
 
  // copiar vetor "s" para o device
  cudaMemcpy(d_s, s, size, cudaMemcpyHostToDevice);

  // chamada do kernel da soma
  add_cuda<<<>>>(a, s, width);

  // copiar o vetor "a" para o host

  printf("\na[%d] = %f\n",width-1,a[width-1]);
  
  cudaFree(d_a);
  cudaFree(d_s);
}
