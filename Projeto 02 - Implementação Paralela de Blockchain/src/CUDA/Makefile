#CC=nvcc
CC=gcc
FLAGS=-lstdc++ -std=c++11 -x c++
CODE=main.cu
EXECUTABLE=Blockchain_CUDA.out

all:
	$(CC) $(FLAGS) $(CODE) -o $(EXECUTABLE)

run: all
	./$(EXECUTABLE)

clean:
	rm $(EXECUTABLE)