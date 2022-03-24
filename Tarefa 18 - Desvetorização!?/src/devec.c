#include <stdio.h>
#include <stdlib.h>

/*
src/devec.c:11:14: missed: statement clobbers memory: __builtin_memset (x_6(D), 1, 1024);
src/devec.c:23:24: missed: couldn't vectorize loop
src/devec.c:23:24: missed: not vectorized: number of iterations cannot be computed.
src/devec.c:20:15: missed: statement clobbers memory: _1 = rand ();
*/

int soma(int a, int b){
    return a+b;
}

void fill(char *x) {
    int i;
    for (i = 0; i < 1024; i++){
        x[i] = 1;
    }
}

int main(int argc, char** argv) {
    int* vetor = (int*) malloc(sizeof(int) * 100*2);

    // Não possui o conhecimento do tamanho do for em run time, até entrar inicializar i 
    // src/devec.c:22:24: missed: not vectorized: number of iterations cannot be computed.
    int tam = rand() % 100;

    // Operação não comutativa
    for(int i = tam; i > 0; i = i / 2) { 

        // Inner loop
        for(int j = 0; j < 12; j++) vetor[j] = vetor[j] * vetor[j + 3]; // read after write

        int a[5] = {0,1,2,3,4};
        int b[5] = {5,6,7,8,9};

        // Read after write
        int i = 1;
        while(i < 5) {
            a[i] = a[i-1] + b[i];
            if(a[i] = 4) break;
            else if(a[i] = 5) break;
            i++;
        }

        // Mais de uma entrada e mais de uma saida
        if(soma(5, 7) > 10) // Chamada de função
            continue;
        
        else {
            char *texto = "Olá";
            fill(texto);
            i = tam;

        }
            
    }

    return 0;   
}