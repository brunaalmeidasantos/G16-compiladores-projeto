#ifndef SEMANTICO_H
#define SEMANTICO_H

#include "../ast/ast.h"
#include "../src/hash.h"

void analise_semantica(NoAST* raiz, HashTable* tabela_global);

#endif