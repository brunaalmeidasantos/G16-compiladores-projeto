#include <stdio.h>
#include "../ast/ast.h"
#include "hash.h"

// Definição das variáveis globais
HashTable *tabela_simbolos = NULL;
NoAST *ast_raiz = NULL;

// Função yyerror para tratamento de erros
void yyerror(const char *s) {
    fprintf(stderr, "Erro de sintaxe: %s\n", s);
}
