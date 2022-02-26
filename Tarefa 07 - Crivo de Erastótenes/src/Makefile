timer=/usr/bin/time -p

paralelo:
	gcc sieve.c -o sieve.out -fopenmp -lm

sequencial:
	gcc sieveSequencial.c -o sieveSequencial.out -lm

rodarParalelo: paralelo
	$(timer) ./sieve.out

rodarSequencial: sequencial
	$(timer) ./sieveSequencial.out
