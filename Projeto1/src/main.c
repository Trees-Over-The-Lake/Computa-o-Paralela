// gcc -O3 -fopenmp -o main main.c -lrt
/*
Teste 01:

Reading input image from testImageGrey.bmp
width = 512
height = 512
iters = 200
clusters = 64

========== CPU CODE RUNNING SEQUENTIALLY ========== 

CPU TIME: 14.29 sec 

========== OMP CODE RUNNING WITH 2 THREADS =========== 

OMP TIME: 18.04 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 4 THREADS =========== 

OMP TIME: 8.99 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 8 THREADS =========== 

OMP TIME: 7.53 sec 
Writing output image to testImage512OMP_out.bmp



Teste 02:

Reading input image from testImageGrey.bmp
width = 512
height = 512
iters = 200
clusters = 64

========== CPU CODE RUNNING SEQUENTIALLY ========== 

CPU TIME: 12.49 sec 

========== OMP CODE RUNNING WITH 2 THREADS =========== 

OMP TIME: 13.60 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 4 THREADS =========== 

OMP TIME: 8.71 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 8 THREADS =========== 

OMP TIME: 7.77 sec 
Writing output image to testImage512OMP_out.bmp



Teste 03:

Reading input image from testImageGrey.bmp
width = 512
height = 512
iters = 200
clusters = 64

========== CPU CODE RUNNING SEQUENTIALLY ========== 

CPU TIME: 12.41 sec 

========== OMP CODE RUNNING WITH 2 THREADS =========== 

OMP TIME: 12.47 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 4 THREADS =========== 

OMP TIME: 6.85 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 8 THREADS =========== 

OMP TIME: 6.17 sec 
Writing output image to testImage512OMP_out.bmp



Teste 04:

Reading input image from testImageGrey.bmp
width = 512
height = 512
iters = 200
clusters = 64

========== CPU CODE RUNNING SEQUENTIALLY ========== 

CPU TIME: 12.38 sec 

========== OMP CODE RUNNING WITH 2 THREADS =========== 

OMP TIME: 13.49 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 4 THREADS =========== 

OMP TIME: 9.05 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 8 THREADS =========== 

OMP TIME: 7.65 sec 
Writing output image to testImage512OMP_out.bmp



Teste 05:

Reading input image from testImageGrey.bmp
width = 512
height = 512
iters = 200
clusters = 64

========== CPU CODE RUNNING SEQUENTIALLY ========== 

CPU TIME: 12.55 sec 

========== OMP CODE RUNNING WITH 2 THREADS =========== 

OMP TIME: 13.48 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 4 THREADS =========== 

OMP TIME: 9.98 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 8 THREADS =========== 

OMP TIME: 8.90 sec 
Writing output image to testImage512OMP_out.bmp
*/


#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <math.h>  
   
#include "kmeans_omp.c"
#include "bmpfuncs.h"
#include "bmpfuncs.c"      
#include "kmeans_ser.c"   

#ifndef GIG
        #define GIG               1000000000
#endif
#ifndef ITERS
        #define ITERS 			 100
#endif
#ifndef TOLERANCE
        #define TOLERANCE 		 0.5
#endif
#ifndef DIM
        #define DIM 		       	 512
#endif
#ifndef CLUSTERS
        #define CLUSTERS 		  4
#endif

int main(int argc, char** argv) {
	float* readImage(const char *filename, int* widthOut, int* heightOut);
	void storeImage(float *imageOut, const char *filename, int rows, int cols, const char* refFilename);
        float* k_means_omp(float *imageIn, int clusters, int dimension, int iterations, int numThreads);
 	float* k_means_serial(float *imageIn, int clusters, int dimension, int iterations);
	float* k_means_serial_optimized(float *imageIn, int clusters, int dimension, int iterations);
        struct timespec diff(struct timespec start, struct timespec end);
        struct timespec time1, time2;
        double begin_clock, end_clock;

        int w = DIM;
        int* width = &w;
	int h = DIM;
        int* height = &h;
	const char *imageInFile =  "testImageGrey.bmp";
        const char *imageOutFile =  "testImage512OMP_out.bmp";
	const char* refFilename = "testImageGrey.bmp";

	float* imageIn = readImage(imageInFile, width, height);

	printf("iters = %d\n", ITERS);
	printf("clusters = %d\n", CLUSTERS);

	printf("\n========== CPU CODE RUNNING SEQUENTIALLY ========== \n\n");
	begin_clock = omp_get_wtime();     
        float *imageOut2 = k_means_serial(imageIn, CLUSTERS, DIM, ITERS);
        end_clock = omp_get_wtime(); 
        printf("CPU TIME: %.2f sec \n", end_clock-begin_clock);

        for(int i = 2; i <= 8; i *= 2) {
	        printf("\n========== OMP CODE RUNNING WITH %d THREADS =========== \n\n", i);
                begin_clock = omp_get_wtime();    
                float *imageOut = k_means_omp(imageIn, CLUSTERS, DIM, ITERS, i);
                end_clock = omp_get_wtime(); 
                printf("OMP TIME: %.2f sec \n", end_clock-begin_clock);
                storeImage(imageOut,imageOutFile, w, h, refFilename);
        }

}


/******TimerStuff*****************/

struct timespec diff(struct timespec start, struct timespec end)
{
  struct timespec temp;
  if ((end.tv_nsec-start.tv_nsec)<0) {
    temp.tv_sec = end.tv_sec-start.tv_sec-1;
    temp.tv_nsec = 1000000000+end.tv_nsec-start.tv_nsec;
  } else {
    temp.tv_sec = end.tv_sec-start.tv_sec;
    temp.tv_nsec = end.tv_nsec-start.tv_nsec;
  }
  return temp;
}

double fRand(double fMin, double fMax)
{
    double f = (double)random() / RAND_MAX;
    return fMin + f * (fMax - fMin);
}

/************************************/
