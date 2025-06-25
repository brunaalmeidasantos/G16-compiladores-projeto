#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

// Função auxiliar para alocar um nó padrão
NoAST* criarNoBase() {
    NoAST *no = (NoAST*) malloc(sizeof(NoAST));
    if (!no) {
        fprintf(stderr, "Falha na alocação de memória para nó da AST\n");
        exit(1);
    }
    no->esq = no->dir = no->ter = NULL;
    no->tipo_expressao = TIPO_ERRO; // Tipo é desconhecido até a análise semântica
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
    no->tipo_expressao = TIPO_INT; // Tipo de um número é sempre INT
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
    no->dir = valor; // O valor da atribuição fica na direita
    return no;
}

// Nó especial para sequências de comandos
NoAST *criarNoBloco(NoAST* bloco_existente, NoAST* novo_comando) {
    if (!bloco_existente) return novo_comando; // Primeiro comando do bloco
    if (!novo_comando) return bloco_existente; // Novo comando é nulo

    NoAST *no = criarNoBase();
    no->op = NODO_BLOCO;
    no->esq = bloco_existente;
    no->dir = novo_comando;
    return no;
}

// Funções auxiliares...
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
    return -1; // Erro
}

Simbolo* criarSimbolo(const char* nome, Tipo tipo, int is_funcao) {
    Simbolo* s = (Simbolo*) malloc(sizeof(Simbolo));
    s->nome = strdup(nome);
    s->tipo = tipo;
    s->is_funcao = is_funcao;
    return s;
}

void imprimirAST(NoAST *no) { /* A lógica de impressão precisa ser atualizada para os novos enums e a estrutura de 3 filhos */ }