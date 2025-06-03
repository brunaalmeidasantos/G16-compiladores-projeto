// semantico/semantico.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semantico.h"

#define TAM_TABELA 100

typedef struct Simbolo {
    char nome[100];
    struct Simbolo *prox;
} Simbolo;

static Simbolo *tabela[TAM_TABELA];

unsigned int hash(const char *str) {
    unsigned int hash = 0;
    while (*str)
        hash = (hash << 5) + *str++;
    return hash % TAM_TABELA;
}

void inicializar_tabela() {
    for (int i = 0; i < TAM_TABELA; i++) {
        tabela[i] = NULL;
    }
}

void adicionar_variavel(const char *nome) {
    if (variavel_declarada(nome)) {
        printf("Erro semântico: variável '%s' já declarada.\n", nome);
        exit(1);
    }

    unsigned int idx = hash(nome);
    Simbolo *novo = (Simbolo *) malloc(sizeof(Simbolo));
    strcpy(novo->nome, nome);
    novo->prox = tabela[idx];
    tabela[idx] = novo;
}

int variavel_declarada(const char *nome) {
    unsigned int idx = hash(nome);
    Simbolo *s = tabela[idx];
    while (s != NULL) {
        if (strcmp(s->nome, nome) == 0)
            return 1;
        s = s->prox;
    }
    return 0;
}

void limpar_tabela() {
    for (int i = 0; i < TAM_TABELA; i++) {
        Simbolo *s = tabela[i];
        while (s != NULL) {
            Simbolo *temp = s;
            s = s->prox;
            free(temp);
        }
        tabela[i] = NULL;
    }
}
