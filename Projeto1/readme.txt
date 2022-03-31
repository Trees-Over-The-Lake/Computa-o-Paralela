	O algoritmo utilizado foi o kmeans. Esse algoritmo foi inventado pensando em separar grupos de elementos com características parecidas em K grupos de elementos. A implementação usada separa grupos de pixels da imagem e clusteriza eles, a imagem gerada com o final "512OMP_out.bmp" é o resultado do agrupamento dos clusters de pixel gerada pelo algoritmo. 
	Foi aumentado o números de clusters do algoritmo para que levasse mais de 10 segundos no parcode. A versão original usava 4 clusters e levava menos de 5 segundos. Aumentando para 64 faz com que o tempo seja superior a 10 segundos.

Algoritmo original feito por rushinmg disponível no github:
https://github.com/rushimg/kmeans_imageSegmentation


Para compilar o programa basta usar o comando make.
Dessa forma

```
make
```

caso queira testar o programa e recompila-lo em apenas um comando, basta usar:

```
make run
```

caso queira apagar o compilado, basta usar:

```
make clean
```

As modificações adicionadas foram feitas no arquivo kmeans_omp.c nas linhas: 29, 38, 40, 59, 61, 78, 80.

Tempos de execução do programa no parcode:

Teste 01:

Reading input image from testImageGrey.bmp
width = 512
height = 512
iters = 200
clusters = 64

========== CPU CODE RUNNING SEQUENTIALLY ========== 

CPU TIME: 14.29 sec 

========== OMP CODE RUNNING WITH 2 THREADS =========== 

OMP TIME: 18.04 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 4 THREADS =========== 

OMP TIME: 8.99 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 8 THREADS =========== 

OMP TIME: 7.53 sec 
Writing output image to testImage512OMP_out.bmp



Teste 02:

Reading input image from testImageGrey.bmp
width = 512
height = 512
iters = 200
clusters = 64

========== CPU CODE RUNNING SEQUENTIALLY ========== 

CPU TIME: 12.49 sec 

========== OMP CODE RUNNING WITH 2 THREADS =========== 

OMP TIME: 13.60 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 4 THREADS =========== 

OMP TIME: 8.71 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 8 THREADS =========== 

OMP TIME: 7.77 sec 
Writing output image to testImage512OMP_out.bmp



Teste 03:

Reading input image from testImageGrey.bmp
width = 512
height = 512
iters = 200
clusters = 64

========== CPU CODE RUNNING SEQUENTIALLY ========== 

CPU TIME: 12.41 sec 

========== OMP CODE RUNNING WITH 2 THREADS =========== 

OMP TIME: 12.47 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 4 THREADS =========== 

OMP TIME: 6.85 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 8 THREADS =========== 

OMP TIME: 6.17 sec 
Writing output image to testImage512OMP_out.bmp



Teste 04:

Reading input image from testImageGrey.bmp
width = 512
height = 512
iters = 200
clusters = 64

========== CPU CODE RUNNING SEQUENTIALLY ========== 

CPU TIME: 12.38 sec 

========== OMP CODE RUNNING WITH 2 THREADS =========== 

OMP TIME: 13.49 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 4 THREADS =========== 

OMP TIME: 9.05 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 8 THREADS =========== 

OMP TIME: 7.65 sec 
Writing output image to testImage512OMP_out.bmp



Teste 05:

Reading input image from testImageGrey.bmp
width = 512
height = 512
iters = 200
clusters = 64

========== CPU CODE RUNNING SEQUENTIALLY ========== 

CPU TIME: 12.55 sec 

========== OMP CODE RUNNING WITH 2 THREADS =========== 

OMP TIME: 13.48 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 4 THREADS =========== 

OMP TIME: 9.98 sec 
Writing output image to testImage512OMP_out.bmp

========== OMP CODE RUNNING WITH 8 THREADS =========== 

OMP TIME: 8.90 sec 
Writing output image to testImage512OMP_out.bmp
