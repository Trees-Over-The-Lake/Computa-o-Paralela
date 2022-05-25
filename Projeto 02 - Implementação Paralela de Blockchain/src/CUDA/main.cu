#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "headers/blockchain.cuh"

#include <iostream>

int main() {
	uint32_t nDifficulty = 5;
	Blockchain bChain = Blockchain(nDifficulty);

	std::cout << "Mining block 1..." << std::endl;
	bChain.AddBlock(new Block(1, "Block 1 Data"));

	std::cout << "Mining block 2..." << std::endl;
	bChain.AddBlock(new Block(2, "Block 2 Data"));

	std::cout << "Mining block 3..." << std::endl;
	bChain.AddBlock(new Block(3, "Block 3 Data"));

	bChain.PrintBlockchain();
	return 0;
}