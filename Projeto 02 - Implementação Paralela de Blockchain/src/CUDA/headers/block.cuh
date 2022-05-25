#ifndef BLOCK_CUH
#define BLOCK_CUH

#include <cstdint>
#include <sstream>

class Block {
public:
    Block(uint32_t nIndexIn, const std::string &sDataIn);

    std::string sPrevHash;
    std::string& GetHash();

    //
    void hostRandomGen(unsigned long long* x);
    // Mine a new block with the given difficulty and return it's ID
    int MineBlock(uint32_t difficulty);
    // Print this block
    void PrintBlock();

private:
    uint32_t _nIndex;
    std::string _sNonce;
    std::string _sData;
    std::string _sHash;
    time_t _tTime;

    // Calculate this block hash
    inline std::string _CalculateHash() const;
}

#endif