#include <stdio.h>
#include <stdlib.h>

/*
******************************
* Tempo do código sequencial *
******************************

real    0m0.437s
user    0m0.197s
sys     0m0.229s

real    0m0.393s
user    0m0.184s
sys     0m0.207s

real    0m0.393s
user    0m0.180s
sys     0m0.211s
*/

/*
*****************************
* Tempo paralelo GPU - CUDA *
*****************************

real    0m1.258s
user    0m0.119s
sys     0m1.053s

real    0m1.112s
user    0m0.117s
sys     0m0.896s

real    0m1.220s
user    0m0.130s
sys     0m0.999s
*/

__global__ void scan_cuda(double* a, double *s, int width) {
  // kernel scan
  int t = threadIdx.x;
  int b = blockIdx.x * blockDim.x;

  double x;

  __shared__ double p[1024];

  if(b+t < width)
    p[t] = a[b+t];

  __syncthreads();

  for(int i = 1; i < blockDim.x; i *= 2) {
    if (t >= i)
      x = p[t] + p[t-i];

      __syncthreads();

      if (t >= i)
        p[t] = x;

      __syncthreads();
  }

  if (b + t < width)
    a[b+t] = p[t];

  if(t == blockDim.x - 1)
    s[blockIdx.x + 1] = a[b+t];
}

__global__ void add_cuda(double *a, double *s, int width) {
  // kernel add
  int t = threadIdx.x;
  int b = blockIdx.x * blockDim.x;

  if (b+t < width)
    a[b+t] += s[blockIdx.x];
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
  cudaMalloc((void **) &d_a, size);
  cudaMalloc((void **) &d_s, size);

  // copiar vetor "a" para o device
  cudaMemcpy(&d_a, a, size, cudaMemcpyHostToDevice);

  // definição do número de blocos e threads (dimGrid e dimBlock)
  dim3 dimGrid(num_blocks, 1, 1);
  dim3 dimBlock(block_size, 1, 1);

  // chamada do kernel scan
  scan_cuda<<<dimGrid, dimBlock>>>(d_a, d_s, width);

  // copiar vetor "s" para o host
  cudaMemcpy(&d_s, s, size, cudaMemcpyDeviceToHost);

  // scan no host (já implementado)
  s[0] = 0;
  for (int i = 1; i < num_blocks; i++)
    s[i] += s[i-1];

  // copiar vetor "s" para o device
  cudaMemcpy(&d_s, s, size, cudaMemcpyHostToDevice);

  // chamada do kernel da soma
  add_cuda<<<dimGrid, dimBlock>>>(a, s, width);

  // copiar o vetor "a" para o host
  cudaMemcpy(&d_a, a, size, cudaMemcpyDeviceToHost);

  printf("\na[%d] = %f\n",width-1,a[width-1]);

  cudaFree(d_a);
  cudaFree(d_s);
}