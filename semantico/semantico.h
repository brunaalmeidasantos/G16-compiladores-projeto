#ifndef SEMANTICO_H
#define SEMANTICO_H

#include "../ast/ast.h"
#include "../src/hash.h"


// Em semantico.h ou similar

// Adicione um tipo para representar um estado indefinido

void analise_semantica(NoAST* raiz, HashTable* tabela_global);

#endif