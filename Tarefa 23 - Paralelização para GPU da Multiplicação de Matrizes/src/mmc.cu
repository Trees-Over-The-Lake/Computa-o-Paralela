
/*
Tempo sequencial:

real    0m31,569s
user    0m31,408s
sys     0m0,077s

real    0m31,120s
user    0m30,967s
sys     0m0,087s

Tempo Paralelo - Multicore:

real    0m9,857s
user    1m1,442s
sys     0m2,972s

real    0m9,663s
user    1m1,498s
sys     0m2,830s

real    0m9,709s
user    1m1,580s
sys     0m3,002s

Tempo paralelo - GPU

real    0m31,675s
user    0m31,759s
sys     0m0,050s

real    0m31,450s
user    0m31,600s
sys     0m0,043s

For paralelo

real    0m9,370s
user    0m54,341s
sys     0m0,196s

real    0m9,421s
user    0m55,248s
sys     0m0,227s

For paralelo com SIMD ativado

real    0m9,144s
user    0m56,485s
sys     0m0,878s

real    0m8,984s
user    0m56,533s
sys     0m0,232s

CUDA:

real    0m0,752s
user    0m0,588s
sys     0m0,138s

real    0m0,693s
user    0m0,559s
sys     0m0,114s

*/

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void mm(double* a, double* b, double* c, int width) {
	int row = blockIdx.y*blockDim.y+threadIdx.y;
	int col = blockIdx.x*blockDim.x+threadIdx.x;

	if((row < width) && (col < width)) {	
		double sum = 0;
		for (int k = 0; k < width; k++) {
			double x = a[i * width + k];
			double y = b[k * width + j];
			sum += x * y;
		}
		c[i * width + j] = sum;
	}
}

int main() {
	int width = 2000;
	double *a = (double*) malloc (width * width * sizeof(double));
	double *b = (double*) malloc (width * width * sizeof(double));
	double *c = (double*) malloc (width * width * sizeof(double));

	for(int i = 0; i < width; i++) {	  
		for(int j = 0; j < width; j++) {
			a[i*width+j] = i;
			b[i*width+j] = j;
			c[i*width+j] = 0;
		}
	}

	int size = width*width*sizeof(double);
	double *d_a, *d_b, *d_c;

	cudaMalloc((void **) &d_a, size);
	cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);

	cudaMalloc((void **) &d_b, size);
	cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

	cudaMalloc((void **) &d_c, size);

	int block_size = 32;
	dim3 dimGrid((width-1)/block_size+1, (width-1)/block_size+1, 1);
	dim3 dimBlock(block_size, block_size, 1);

	mm<<<dimGrid, dimBlock>>>(d_a, d_b, d_c, width);

	cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

	/*
	for(int i = 0; i < width; i++) {
		for(int j = 0; j < width; j++) {
			printf("\n c[%d][%d] = %lf",i,j,c[i*width+j]);
		}
	}
	*/

	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
}