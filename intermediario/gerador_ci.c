#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "gerador_ci.h"

static int temp_count = 0;
static int label_count = 0;

char* novo_temp() {
    char* temp = malloc(10);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}

char* novo_rotulo() {
    char* label = malloc(10);
    sprintf(label, "L%d", label_count++);
    return label;
}

const char* op_para_string(Operador op) {
    switch (op) {
        case OP_SOMA: return "+";
        case OP_SUB: return "-";
        case OP_MUL: return "*";
        case OP_DIV: return "/";
        case OP_EQ: return "==";
        case OP_NE: return "!=";
        case OP_LT: return "<";
        case OP_LE: return "<=";
        case OP_GT: return ">";
        case OP_GE: return ">=";
        case OP_AND: return "&&";
        case OP_OR: return "||";
        default: return "?";
    }
}

char* gerar_expressao(NoAST *no) {
    if (!no) return NULL;

    switch (no->op) {
        case NODO_NUM: {
            char* s = malloc(20);
            sprintf(s, "%d", no->valor_int);
            return s;
        }
        case NODO_FLOAT: {
            char* s = malloc(30);
            sprintf(s, "%f", no->valor_float);
            return s;
        }
        case NODO_BOOL: {
            char* s = malloc(10);
            sprintf(s, "%d", no->valor_int);
            return s;
        }
        case NODO_STRING: {
            char* s = malloc(strlen(no->valor_string) + 3);
            sprintf(s, "\"%s\"", no->valor_string);
            return s;
        }
        case NODO_ID:
            return strdup(no->nome);

        case OP_MENOS_UNARIO:
        case OP_NOT: {
            char* operando = gerar_expressao(no->esq);
            char* temp = novo_temp();
            const char* op_str = (no->op == OP_MENOS_UNARIO) ? "-" : "!";
            printf("%s = %s %s\n", temp, op_str, operando);
            free(operando);
            return temp;
        }

        case NODO_CHAMADA_FUNC: {
            NoAST* args = no->dir;
            int arg_count = 0;
            while(args != NULL) {
                char* arg_val = gerar_expressao(args->dir);
                printf("param %s\n", arg_val);
                free(arg_val);
                args = args->esq;
                arg_count++;
            }
            char* nome_funcao = gerar_expressao(no->esq);
            char* temp = novo_temp();
            printf("%s = call %s, %d\n", temp, nome_funcao, arg_count);
            free(nome_funcao);
            return temp;
        }

        default: {
            char* esq = gerar_expressao(no->esq);
            char* dir = gerar_expressao(no->dir);
            char* temp = novo_temp();
            printf("%s = %s %s %s\n", temp, esq, op_para_string(no->op), dir);
            free(esq);
            free(dir);
            return temp;
        }
    }
}

void gerar_statement(NoAST *no) {
    if (!no) return;

    switch (no->op) {
        case NODO_BLOCO:
            gerar_statement(no->esq);
            gerar_statement(no->dir);
            break;

        case NODO_ATRIBUICAO: {
            char* val = gerar_expressao(no->dir);
            printf("%s = %s\n", no->nome, val);
            free(val);
            break;
        }
        
        case NODO_PRINT: {
            char* val = gerar_expressao(no->esq);
            printf("print %s\n", val);
            free(val);
            break;
        }

        case NODO_IF: {
            char* cond = gerar_expressao(no->esq);
            char* rotulo_else = novo_rotulo();
            char* rotulo_fim = novo_rotulo();
            
            printf("if_false %s goto %s\n", cond, rotulo_else);
            free(cond);

            gerar_statement(no->dir);
            printf("goto %s\n", rotulo_fim);

            printf("label %s\n", rotulo_else);
            if (no->ter) {
                gerar_statement(no->ter);
            }

            printf("label %s\n", rotulo_fim);
            free(rotulo_else);
            free(rotulo_fim);
            break;
        }

        case NODO_WHILE: {
            char* rotulo_inicio = novo_rotulo();
            char* rotulo_fim = novo_rotulo();
            
            printf("label %s\n", rotulo_inicio);
            char* cond = gerar_expressao(no->esq);
            printf("if_false %s goto %s\n", cond, rotulo_fim);
            free(cond);

            gerar_statement(no->dir);
            printf("goto %s\n", rotulo_inicio);

            printf("label %s\n", rotulo_fim);
            free(rotulo_inicio);
            free(rotulo_fim);
            break;
        }
        
        case NODO_FUNC_DEF: {
            printf("\ndef %s:\n", no->nome);
            gerar_statement(no->dir);
            printf("end_def\n\n");
            break;
        }

        case NODO_RETURN: {
            if (no->esq) {
                char* val = gerar_expressao(no->esq);
                printf("return %s\n", val);
                free(val);
            } else {
                printf("return\n");
            }
            break;
        }

        case OP_BREAK:
            printf("break\n");
            break;
        
        case OP_CONTINUE:
            printf("continue\n");
            break;

        default:
            free(gerar_expressao(no));
            break;
    }
}

void gerar_codigo_intermediario(NoAST *raiz) {
    temp_count = 0;
    label_count = 0;
    gerar_statement(raiz);
}