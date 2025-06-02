#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../src/hash.h"

int main() {
    HashTable* tabela_simbolos = create_table();

    // Simulando declaração de variáveis em Python
    insert(tabela_simbolos, "x", "int");
    insert(tabela_simbolos, "y", "float");

    // Simulando uso de variáveis (como se estivesse analisando uma linha do tipo: x = 5)
    if (search(tabela_simbolos, "x") != NULL) {
        printf("Variável 'x' já declarada\n");
    } else {
        printf("Erro: variável 'x' não declarada\n");
    }

    if (search(tabela_simbolos, "z") != NULL) {
        printf("Variável 'z' já declarada\n");
    } else {
        printf("Erro: variável 'z' não declarada\n");
    }

    free_table(tabela_simbolos);
    printf("se voce esta lendo isso significa que a tabela de simbolos está funcionando\n");
    return 0;
}
