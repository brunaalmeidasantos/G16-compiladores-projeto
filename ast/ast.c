#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

NoAST* criarNoBase() {
    NoAST *no = (NoAST*) malloc(sizeof(NoAST));
    if (!no) {
        fprintf(stderr, "Falha na alocação de memória para nó da AST\n");
        exit(1);
    }
    no->esq = no->dir = no->ter = NULL;
    no->tipo_expressao = TIPO_ERRO; // O tipo será definido na análise semântica
    return no;
}

NoAST *criarNoOp(Operador op, NoAST *esq, NoAST *dir) {
    NoAST *no = criarNoBase();
    no->op = op;
    no->esq = esq;
    no->dir = dir;
    return no;
}

NoAST *criarNoNum(int val) {
    NoAST *no = criarNoBase();
    no->op = NODO_NUM;
    no->valor_int = val;
    no->tipo_expressao = TIPO_INT;
    return no;
}

NoAST *criarNoId(char *nome) {
    NoAST *no = criarNoBase();
    no->op = NODO_ID;
    strncpy(no->nome, nome, 99);
    no->nome[99] = '\0';
    return no;
}

NoAST *criarNoString(char *valor) {
    NoAST *no = criarNoBase();
    no->op = NODO_STRING;
    no->valor_string = strdup(valor);
    no->tipo_expressao = TIPO_STRING;
    return no;
}

NoAST *criarNoBool(int valor) {
    NoAST *no = criarNoBase();
    no->op = NODO_BOOL;
    no->valor_int = valor;
    no->tipo_expressao = TIPO_BOOL;
    return no;
}

NoAST *criarNoNone() {
    NoAST *no = criarNoBase();
    no->op = NODO_NONE;
    no->tipo_expressao = TIPO_NONE;
    return no;
}

NoAST *criarNoIf(NoAST *condicao, NoAST *corpo_if, NoAST *corpo_else) {
    NoAST *no = criarNoBase();
    no->op = NODO_IF;
    no->esq = condicao;
    no->dir = corpo_if;
    no->ter = corpo_else;
    return no;
}

NoAST *criarNoWhile(NoAST *condicao, NoAST *corpo) {
    NoAST *no = criarNoBase();
    no->op = NODO_WHILE;
    no->esq = condicao;
    no->dir = corpo;
    return no;
}

NoAST *criarNoAtribuicao(char *nome, NoAST *valor) {
    NoAST *no = criarNoBase();
    no->op = NODO_ATRIBUICAO;
    strncpy(no->nome, nome, 99);
    no->nome[99] = '\0';
    no->dir = valor;
    return no;
}

NoAST *criarNoBloco(NoAST* stmts, NoAST* nova_stmt) {
    NoAST *no = criarNoBase();
    no->op = NODO_BLOCO;
    no->esq = stmts;
    no->dir = nova_stmt;
    return no;
}

NoAST *criarNoFuncao(char *nome, NoAST *parametros, NoAST *corpo) {
    NoAST *no = criarNoBase();
    no->op = NODO_FUNC_DEF;
    strncpy(no->nome, nome, 99);
    no->nome[99] = '\0';
    no->esq = parametros;
    no->dir = corpo;
    return no;
}

NoAST* criarNoFlow(Operador op_fluxo) {
    NoAST* no = criarNoBase();
    no->op = op_fluxo; // OP_BREAK ou OP_CONTINUE
    return no;
}

NoAST* criarNoChamadaFunc(NoAST* argumentos) {
    NoAST* no = criarNoBase();
    no->op = NODO_CHAMADA_FUNC;
    no->dir = argumentos; // A expressão da função será ligada em 'esq' no parser
    return no;
}

NoAST* criarNoListaArgs(NoAST* lista, NoAST* novo_arg) {
    NoAST* no = criarNoBase();
    no->op = NODO_LISTA_ARGS;
    no->esq = lista;
    no->dir = novo_arg;
    return no;
}

NoAST* criarNoFor(char* var, NoAST* iteravel, NoAST* corpo) {
    NoAST* no = criarNoBase();
    no->op = NODO_FOR;
    strncpy(no->nome, var, 99);
    no->nome[99] = '\0';
    no->esq = iteravel;
    no->dir = corpo;
    return no;
}

NoAST* criarNoReturn(NoAST* valor_retorno) {
    NoAST* no = criarNoBase();
    no->op = NODO_RETURN;
    no->esq = valor_retorno; // Pode ser NULL
    return no;
}

NoAST* criarNoPrint(NoAST* expressao) {
    NoAST* no = criarNoBase();
    no->op = NODO_PRINT;
    no->esq = expressao;
    no->dir = NULL;
    no->ter = NULL;
    return no;
}

/* --- Funções Auxiliares --- */

const char* tipo_para_string(Tipo tipo) {
    switch (tipo) {
        case TIPO_INT: return "int";
        case TIPO_STRING: return "string";
        case TIPO_BOOL: return "bool";
        case TIPO_NONE: return "none";
        case TIPO_FUNCAO: return "function";
        default: return "erro";
    }
}

Tipo tipo_from_string(const char* s) {
    if (strcmp(s, "int") == 0) return TIPO_INT;
    if (strcmp(s, "string") == 0) return TIPO_STRING;
    if (strcmp(s, "bool") == 0) return TIPO_BOOL;
    return TIPO_ERRO;
}

Operador op_from_string(const char* s) {
    if (strcmp(s, "==") == 0) return OP_EQ;
    if (strcmp(s, "!=") == 0) return OP_NE;
    if (strcmp(s, "<") == 0) return OP_LT;
    if (strcmp(s, "<=") == 0) return OP_LE;
    if (strcmp(s, ">") == 0) return OP_GT;
    if (strcmp(s, ">=") == 0) return OP_GE;
    return -1;
}

Simbolo* criarSimbolo(const char* nome, Tipo tipo, int is_funcao) {
    Simbolo* s = (Simbolo*) malloc(sizeof(Simbolo));
    s->nome = strdup(nome);
    s->tipo = tipo;
    s->is_funcao = is_funcao;
    return s;
}

// A implementação de imprimirAST precisa ser expandida
void imprimirAST(NoAST *no) {
    if (!no) return;
    printf("(Nó op: %d)", no->op);
}
