CC=nvcc
#CC=gcc
#FLAGS=-lstdc++ -std=c++11 -x c++
CODE=main.cu backend/block.cu backend/blockchain.cu backend/sha256.cu
EXECUTABLE=Blockchain_CUDA.out

all:
	$(CC) -w $(CODE) -o $(EXECUTABLE)

run: all
	./$(EXECUTABLE)

clean:
	rm $(EXECUTABLE)
