// semantico/semantico.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semantico.h"

#define MAX_VARS 100

char* tabela_simbolos[MAX_VARS];
int total_vars = 0;

void inicializar_tabela_simbolos() {
    total_vars = 0;
}

void finalizar_tabela_simbolos() {
    for (int i = 0; i < total_vars; i++) {
        free(tabela_simbolos[i]);
    }
}

void declarar_variavel(const char* nome) {
    tabela_simbolos[total_vars++] = strdup(nome);
}

int verificar_variavel_declarada(const char* nome) {
    for (int i = 0; i < total_vars; i++) {
        if (strcmp(tabela_simbolos[i], nome) == 0) return 1;
    }
    return 0;
}

void erro_semantico(const char* mensagem) {
    fprintf(stderr, "[Erro Semântico] %s\n", mensagem);
    exit(1);
}
