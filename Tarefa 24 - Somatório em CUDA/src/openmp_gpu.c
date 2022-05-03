#include <stdio.h>

int main() {
    int width = 40000000;
    int size = width * sizeof(double);
    double sum = 0;

    #pragma omp target teams distribute parallel for simd map(tofrom:sum) map(to:width) reduction(+:sum) 
    for(int i = 0; i < width; i++) {
        sum += i;
    }

    printf("%lf \n", sum);
}