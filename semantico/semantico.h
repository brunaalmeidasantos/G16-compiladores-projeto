#ifndef SEMANTICO_H
#define SEMANTICO_H

#include "../ast/ast.h"
#include "../src/hash.h" // Precisa da definição da HashTable

// Função principal que inicia a análise semântica
void analise_semantica(NoAST* raiz, HashTable* tabela_global);

#endif