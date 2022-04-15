all:
	gcc -lstdc++ -std=c++11 -x c++ main.cpp Block.cpp Blockchain.cpp sha256.cpp

parcode:
	gcc8 -lstdc++ -std=c++11 -x c++ main.cpp Block.cpp Blockchain.cpp sha256.cpp

run: all
	./a.out

runParcode: parcode
	./a.out 