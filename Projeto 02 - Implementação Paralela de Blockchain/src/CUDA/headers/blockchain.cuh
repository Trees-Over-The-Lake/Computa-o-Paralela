#ifndef BLOCKCHAIN_CUH
#define BLOCKCHAIN_CUH

#include <cstdint>
#include <vector>
#include "block.cuh"

class Blockchain {
public:
	Blockchain(uint32_t nDifficulty);

	void AddBlock(Block* bNew);
	void PrintBlockchain();

private:
	uint32_t _nDifficulty;
	std::vector<Block*> _vChain;

	Block* _GetLastBlock() const;
};

#endif