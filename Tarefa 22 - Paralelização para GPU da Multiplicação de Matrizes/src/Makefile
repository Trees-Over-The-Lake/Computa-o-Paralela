CC=gcc -O3
SEQUENCIAL=sequencial.c 
PARALELO=paralelo.c
GPU=gpu.c

TIME=/usr/bin/time -p

sequencial:
	$(CC) $(SEQUENCIAL)
	$(TIME) ./a.out

paralelo:
	$(CC) -fopenmp $(PARALELO)
	$(TIME) ./a.out

gpu:
	$(CC) -fopenmp $(GPU)
	$(TIME) ./a.out

all: sequencial paralelo gpu
	echo "Foram todos"