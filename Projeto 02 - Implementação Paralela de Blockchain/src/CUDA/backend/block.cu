#include <algorithm>
#include "../headers/block.cu"
#include "../headers/sha256.cuh"
#include "../headers/sha256Host.cuh"

#define THREADS 1500
#define BLOCKS 256
#define DIFFICULTY 3
#define RANDOM_LEN 20

typedef unsigned char BYTE;

__constant__ BYTE characterSet[63] = {"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"};

__device__ unsigned long long deviceRandomGen(unsigned long long x) {
    x ^= (x << 21);
    x ^= (x >> 35);
    x ^= (x << 4);
    return x;
}

__global__ void sha256_cuda(BYTE* input, BYTE* solution, int* blockContainsSolution, unsigned long long baseSeed, size_t textLen) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    unsigned long long seed = baseSeed;
    seed += (unsigned long long) i;

    BYTE digest[32];
    BYTE random[RANDOM_LEN];
    memset(digest, 0, SHA256::DIGEST_SIZE);
    memset(random, 0, RANDOM_LEN);

    for(int j = 0; j < RANDOM_LEN; j++) {
        seed = deviceRandomGen(seed);
        int randomIdx = (int) (seed % 62);
        random[j] = characterSet[randomIdx];
    }

    SHA256CUDA::sha256(input, random, textLen, RANDOM_LEN, digest);

    for(int j = 0; j < DIFFICULTY; j++) 
        if(digest[j] > 0)
            return 0;
    
    if(*blockContainsSolution == 1) 
        return;

    *blockContainsSolution = 1;

    for(int j = 0; j < RANDOM_LEN; j++) 
        solution[j] = random[j];
}

__global__ void initSolutionMemory() {