#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

// Implementações originais do professor
NoAST *criarNoOp(char op, NoAST *esq, NoAST *dir) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = op;
    no->esquerda = esq;
    no->direita = dir;
    no->tipo = (esq->tipo == dir->tipo) ? esq->tipo : TIPO_ERRO;
    return no;
}

NoAST *criarNoNum(int val) {
    NoAST *no = malloc(sizeof(NoAST));
    no->valor = val;
    no->operador = 0;
    no->tipo = TIPO_INT;
    no->esquerda = no->direita = NULL;
    return no;
}

NoAST *criarNoId(char *nome, Tipo tipo) {
    NoAST *no = malloc(sizeof(NoAST));
    strncpy(no->nome, nome, 31);
    no->nome[31] = '\0';
    no->operador = 0;
    no->tipo = tipo;
    no->esquerda = no->direita = NULL;
    return no;
}

// Novas implementações para suportar Python
NoAST *criarNoString(char *valor) {
    NoAST *no = malloc(sizeof(NoAST));
    strncpy(no->nome, valor, 31);
    no->nome[31] = '\0';
    no->operador = 0;
    no->tipo = TIPO_STRING;
    no->esquerda = no->direita = NULL;
    return no;
}

NoAST *criarNoBool(int valor) {
    NoAST *no = malloc(sizeof(NoAST));
    no->valor = valor;
    no->operador = 0;
    no->tipo = TIPO_BOOL;
    no->esquerda = no->direita = NULL;
    return no;
}

NoAST *criarNoNone() {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = 0;
    no->tipo = TIPO_NONE;
    no->esquerda = no->direita = NULL;
    return no;
}

NoAST *criarNoIf(NoAST *condicao, NoAST *corpo, NoAST *corpo_else) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = '?'; // Usamos '?' para representar if
    no->tipo = corpo->tipo; // Tipo do resultado é o tipo do corpo
    no->if_stmt.condicao = condicao;
    no->if_stmt.corpo = corpo;
    no->if_stmt.corpo_else = corpo_else;
    return no;
}

NoAST *criarNoWhile(NoAST *condicao, NoAST *corpo) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = 'W'; // 'W' para while
    no->tipo = TIPO_NONE; // Loops não retornam valor
    no->loop.condicao = condicao;
    no->loop.corpo = corpo;
    return no;
}

NoAST *criarNoAtribuicao(char *nome, NoAST *valor) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = '='; // Operador de atribuição
    no->tipo = valor->tipo;
    strncpy(no->nome, nome, 31);
    no->nome[31] = '\0';
    no->esquerda = NULL;
    no->direita = valor;
    return no;
}

NoAST *criarNoFuncao(char *nome, NoAST *parametros, NoAST *corpo) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = 'F';  // 'F' para função
    no->tipo = TIPO_NONE;

    strncpy(no->nome, nome, 31);
    no->nome[31] = '\0';

    no->funcao.nome_funcao = nome;
    no->funcao.parametros = parametros;
    no->funcao.corpo = corpo;

    no->esquerda = NULL;
    no->direita = NULL;

    return no;
}

void imprimirAST(NoAST *no) {
    if (!no) return;
    
    switch(no->operador) {
        case 0: // Nó folha (número, string, etc)
            if (no->tipo == TIPO_INT) printf("%d", no->valor);
            else if (no->tipo == TIPO_STRING) printf("\"%s\"", no->nome);
            else if (no->tipo == TIPO_BOOL) printf(no->valor ? "True" : "False");
            else if (no->tipo == TIPO_NONE) printf("None");
            else printf("%s", no->nome);
            break;
            
        case '?': // If
            printf("if (");
            imprimirAST(no->if_stmt.condicao);
            printf(") {\n");
            imprimirAST(no->if_stmt.corpo);
            if (no->if_stmt.corpo_else) {
                printf("\n} else {\n");
                imprimirAST(no->if_stmt.corpo_else);
            }
            printf("\n}");
            break;
            
        case 'W': // While
            printf("while (");
            imprimirAST(no->loop.condicao);
            printf(") {\n");
            imprimirAST(no->loop.corpo);
            printf("\n}");
            break;
            
        case '=': // Atribuição
            printf("%s = ", no->nome);
            imprimirAST(no->direita);
            break;
            
        default: // Operadores binários
            printf("(");
            imprimirAST(no->esquerda);
            printf(" %c ", no->operador);
            imprimirAST(no->direita);
            printf(")");
    }
}

int tiposCompativeis(Tipo t1, Tipo t2) {
    // Adicione regras de conversão implícita se necessário
    return t1 == t2;
}