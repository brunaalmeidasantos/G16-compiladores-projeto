#ifndef GERADOR_CI_H
#define GERADOR_CI_H

#include "../ast/ast.h"

// Declarações das funções principais
void gerar_codigo_intermediario(NoAST *raiz);
void gerar_statement(NoAST *no);
char* gerar_expressao(NoAST *no);

// Funções auxiliares
char* novo_temp(void);
char* novo_rotulo(void);
const char* op_para_string(Operador op);

#endif