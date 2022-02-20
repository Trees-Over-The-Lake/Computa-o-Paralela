#!/bin/bash


# Compilador e suas flags para a compilação
compilador=gcc
flagOtimizadora="-O3"
flags="-fopenmp ${flagOtimizadora}"

# Ferramentas usadas
tempo="/usr/bin/time -p"

# Outputs do compilador
outSequencial="sequencial"
outParalelo="paralelo"

# Arquivos de saidas dos programas
saidaSequencial="sequencial.txt"
saidaParalela="paralelo.txt"
tempoSequencial="tempoSequencial.txt"
tempoParalelo="tempoParalelo.txt"

# Função para deletar arquivos temporários
deleteTmpFilesAndExit() {
    rm -rf $saidaSequencial $saidaParalela $tempoSequencial $tempoParalelo $outSequencial $outParalelo;
    exit;
}

# Verficando se foram passados todos os argumentos necessários
# para o script rodar
if [[ $# -lt 2 ]];
then
    echo "";
    echo "Por favor passe como parametro do script o endereço do código sequêncial e depois sua versão paralela assim: ";
    echo "${0} sequencial.c paralelo.c";
    echo "";
    deleteTmpFilesAndExit
fi

# Compilando a versão sequêncial
$compilador -o $outSequencial $flagOtimizadora "$1"

# Compilando a versão paralela
$compilador -o $outParalelo $flags "$2"

# Testar sequêncial
$tempo -o $tempoSequencial ./$outSequencial > $saidaSequencial
echo "" >> $tempoSequencial    

# Testar paralelo
$tempo -o $tempoParalelo ./$outParalelo > $saidaParalela
echo "" >> $tempoParalelo

# Testar saídas
if [[ $(git diff --exit-code $saidaSequencial $saidaParalela) == 0 ]];
then
    echo "A saída dos dois arquivos são diferentes!"
    deleteTmpFilesAndExit
fi

# Testar tempo sequêncial
for i in {0..9};
do
    $tempo -a -o $tempoSequencial ./$outSequencial > /dev/null;
    echo "" >> $tempoSequencial;
done

# Testar tempo paralelo
for i in {0..9};
do
    $tempo -a -o $tempoParalelo ./$outParalelo > /dev/null;
    echo "" >> $tempoParalelo;
done