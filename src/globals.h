#ifndef GLOBALS_H
#define GLOBALS_H

#include "../ast/ast.h"
#include "hash.h"
#include <stdio.h>

// =================================================================
// DECLARAÇÃO EXTERNA DAS VARIÁVEIS GLOBAIS
// 'extern' diz ao compilador: "esta variável existe, mas
// sua memória está alocada em outro arquivo C (globals.c)".
// =================================================================

// CORREÇÃO: Padronizado para o nome usado no parser.
extern HashTable *tabela_simbolos_global;
extern NoAST *ast_raiz;

// =================================================================
// PROTÓTIPO DA FUNÇÃO GLOBAL
// Informa aos outros arquivos a assinatura da função yyerror.
// =================================================================

void yyerror(const char *s);

#endif // GLOBALS_H
