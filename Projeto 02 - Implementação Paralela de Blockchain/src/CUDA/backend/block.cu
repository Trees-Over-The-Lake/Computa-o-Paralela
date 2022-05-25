#include <algorithm>
#include <iostream>

#include "../headers/block.cuh"
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
            return;
    
    if(*blockContainsSolution == 1) 
        return;

    *blockContainsSolution = 1;

    for(int j = 0; j < RANDOM_LEN; j++) 
        solution[j] = random[j];
}

__global__ void initSolutionMemory(int *blockContainsSolution) {
    *blockContainsSolution = -1;
}

Block::Block(uint32_t nIndexIn, const std::string& sDataIn) {
    _sNonce = "-1";
    _nIndex = nIndexIn;
    _tTime = time(nullptr);
    _sData = sDataIn;
    _sHash = _CalculateHash();
}

std::string& Block::GetHash() {
    return _sHash;
}

// Gerando um pseudo random code
void Block::hostRandomGen(unsigned long long *x) {
    *x ^= (*x << 21);
    *x ^= (*x >> 35);
    *x ^= (*x << 4);
}

// Minerar um bloco usando da dificuldade e retornando a ID do bloco
int Block::MineBlock(uint32_t nDifficulty) {
    bool solution = false;

    std::stringstream ss;
    ss << _nIndex << _tTime << _sData << sPrevHash;

    std::string x = ss.str();

    BYTE* d_input;
    BYTE* input = (BYTE*) x.c_str();
    // Movendo os dados para a GPU
    cudaMalloc(&d_input, sizeof(BYTE) * x.length());
    cudaMemcpy(d_input, input, sizeof(BYTE) * x.length(), cudaMemcpyHostToDevice);

    BYTE* blockSolution = (BYTE*) malloc(sizeof(BYTE) * RANDOM_LEN);
    BYTE* d_solution;
    cudaMalloc(&d_solution, sizeof(BYTE) * RANDOM_LEN);

    int *blockContainsSolution = (int*) malloc(sizeof(int));
    int *d_blockContainsSolution;
    cudaMalloc(&d_blockContainsSolution, sizeof(int));
    
    unsigned long long rngSeed = static_cast<unsigned long long>(time(nullptr));

    initSolutionMemory<<<1, 1>>>(d_blockContainsSolution);

    while(!solution) {
        hostRandomGen(&rngSeed);

        sha256_cuda<<<THREADS, BLOCKS>>>(d_input, d_solution, d_blockContainsSolution, rngSeed, x.length());
        cudaDeviceSynchronize();

        cudaMemcpy(blockContainsSolution, d_blockContainsSolution, sizeof(int), cudaMemcpyDeviceToHost);

        if(*blockContainsSolution == 1) {
            cudaMemcpy(blockSolution, d_solution, sizeof(BYTE) * RANDOM_LEN, cudaMemcpyDeviceToHost);
            solution = true;

            break;
        }
    }

    cudaDeviceReset();

    _sNonce = std::string((const char*) blockSolution);
    _sHash = _CalculateHash();
    
    return -1;
}

void Block::PrintBlock() {
    std::cout << "-----------" << "Block " << _nIndex << "-----------" << "\n";
    std::cout << "Nonce: " << _sNonce << "\n";
    std::cout << "Hash: " << _sHash << "\n";
    std::cout << "Previous Hash: " << sPrevHash << "\n";
    std::cout << "Data: " << _sData << "\n";
    std::cout << "Time: " << _tTime << "\n";
}

inline std::string Block::_CalculateHash() const {
    std::stringstream ss;
    ss << _nIndex << _tTime << _sData << sPrevHash << _sNonce;

    return sha256(ss.str());
}