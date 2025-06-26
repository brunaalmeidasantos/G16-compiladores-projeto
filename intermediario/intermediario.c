#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"
#include "intermediario.h"

int temp_count = 0;

char* nova_temp() {
    char* nome = (char*) malloc(16);
    sprintf(nome, "t%d", temp_count++);
    return nome;
}

void gerar_codigo(AST* raiz) {
    if (!raiz) return;

    switch (raiz->tipo) {
        case AST_NUMERO:
            printf("%d", raiz->valor);
            break;

        case AST_IDENT:
            printf("%s", raiz->nome);
            break;

        case AST_BINOP: {
            char* t1 = nova_temp();
            char* t2 = nova_temp();
            printf("%s = ", t1);
            gerar_codigo(raiz->filhos[0]);
            printf("\n");
            printf("%s = ", t2);
            gerar_codigo(raiz->filhos[1]);
            printf("\n");

            char* resultado = nova_temp();
            printf("%s = %s %s %s\n", resultado, t1, raiz->op, t2);

            free(t1);
            free(t2);
            free(resultado);
            break;
        }

        case AST_ASSIGN:
            printf("%s = ", raiz->nome);
            gerar_codigo(raiz->filhos[0]);
            printf("\n");
            break;

        default:
            for (int i = 0; i < raiz->num_filhos; i++) {
                gerar_codigo(raiz->filhos[i]);
            }
    }
}

void gerar_codigo_intermediario(AST* raiz) {
    printf("Codigo Intermediario:\n");
    gerar_codigo(raiz);
}
