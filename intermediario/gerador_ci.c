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
            // Primeiro, gera o código para os argumentos e os empilha (simulado com 'param')
            NoAST* no_arg = no->dir;
            int arg_count = 0;
            while (no_arg != NULL) {
                char* arg_val;
                // Se for um nó da lista, o argumento está na direita (dir)
                if (no_arg->op == NODO_LISTA_ARGS) {
                    arg_val = gerar_expressao(no_arg->dir);
                    no_arg = no_arg->esq; // Avança para o resto da lista
                } else {
                // Se não for, este é o último (ou único) argumento
                    arg_val = gerar_expressao(no_arg);
                    no_arg = NULL; // Fim da lista
                }
                printf("param %s\n", arg_val);
                free(arg_val);
                arg_count++;
            }

            // Agora, gera a instrução de chamada
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

        case NODO_FOR: {
            // Assumimos a estrutura do seu nó NODO_FOR:
            // no->nome: a variável do laço (ex: "i")
            // no->esq:  o iterável, que para range(100) será um NODO_NUM com valor 100
            // no->dir:  o corpo do laço

            char* var_loop = no->nome;
            char* rotulo_inicio = novo_rotulo();
            char* rotulo_fim = novo_rotulo();

            // 1. Inicializa a variável do laço: i = 0
            printf("%s = 0\n", var_loop);

            // 2. Define o rótulo de início do laço
            printf("label %s\n", rotulo_inicio);

            // 3. Gera a condição de parada: if (i < limite)
            char* limite = gerar_expressao(no->esq); // Obtém o "100"
            char* temp_cond = novo_temp();
            printf("%s = %s < %s\n", temp_cond, var_loop, limite);
            printf("if_false %s goto %s\n", temp_cond, rotulo_fim);
            free(limite);
            free(temp_cond);

            // 4. Gera o código para o corpo do laço
            gerar_statement(no->dir);

            // 5. Gera o incremento: i = i + 1
            char* temp_inc = novo_temp();
            printf("%s = %s + 1\n", temp_inc, var_loop);
            printf("%s = %s\n", var_loop, temp_inc);
            free(temp_inc);

            // 6. Volta para o início para a próxima iteração
            printf("goto %s\n", rotulo_inicio);

            // 7. Define o rótulo de fim do laço
            printf("label %s\n", rotulo_fim);

            free(rotulo_inicio);
            free(rotulo_fim);
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