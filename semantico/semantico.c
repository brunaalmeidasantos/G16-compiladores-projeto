#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semantico.h"

static void visitar_no(NoAST* no, HashTable* escopo, Simbolo* funcao_atual, int dentro_de_loop);
static void visitar_lista_parametros(NoAST* no, HashTable* escopo_funcao);

void analise_semantica(NoAST* raiz, HashTable* tabela_global) {
    if (!raiz) return;
    visitar_no(raiz, tabela_global, NULL, 0);
}

void erro_semantico(const char* mensagem, const char* detalhe) {
    fprintf(stderr, "[Erro Semântico] %s: %s\n", mensagem, detalhe);
    exit(1);
}


// FUNÇÃO PRINCIPAL QUE PERCORRE A AST RECURSIVAMENTE
static void visitar_no(NoAST* no, HashTable* escopo, Simbolo* funcao_atual, int dentro_de_loop) {
    if (!no) return;

    switch(no->op) {
        /* --- Nós Folha --- */
        case NODO_NUM: no->tipo_expressao = TIPO_INT; break;
        case NODO_STRING: no->tipo_expressao = TIPO_STRING; break;
        case NODO_BOOL: no->tipo_expressao = TIPO_BOOL; break;
        case NODO_NONE: no->tipo_expressao = TIPO_NONE; break;
        case NODO_ID: {
            // Quando uma variável é USADA, ela DEVE existir.
            Simbolo* s = search(escopo, no->nome);
            if (s == NULL) {
                erro_semantico("Variável ou função não declarada antes do uso", no->nome);
            }
            no->tipo_expressao = s->tipo;
            break;
        }

        /* --- Operadores de Expressão --- */
        case OP_SOMA: case OP_SUB: case OP_MUL: case OP_DIV: {
            visitar_no(no->esq, escopo, funcao_atual, dentro_de_loop);
            visitar_no(no->dir, escopo, funcao_atual, dentro_de_loop);
            if (no->esq->tipo_expressao != TIPO_INT || no->dir->tipo_expressao != TIPO_INT) {
                erro_semantico("Operandos de operação aritmética devem ser do tipo 'int'", "");
            }
            no->tipo_expressao = TIPO_INT;
            break;
        }
        case OP_EQ: case OP_NE: case OP_LT: case OP_LE: case OP_GT: case OP_GE: {
            visitar_no(no->esq, escopo, funcao_atual, dentro_de_loop);
            visitar_no(no->dir, escopo, funcao_atual, dentro_de_loop);
            if (no->esq->tipo_expressao != no->dir->tipo_expressao) {
                erro_semantico("Tipos incompatíveis para operação de comparação", "");
            }
            no->tipo_expressao = TIPO_BOOL;
            break;
        }

        case OP_AND: case OP_OR: {
            visitar_no(no->esq, escopo, funcao_atual, dentro_de_loop);
            visitar_no(no->dir, escopo, funcao_atual, dentro_de_loop);
            if (no->esq->tipo_expressao != TIPO_BOOL || no->dir->tipo_expressao != TIPO_BOOL) {
                erro_semantico("Operandos de operação lógica 'and'/'or' devem ser do tipo 'bool'", "");
            }
            no->tipo_expressao = TIPO_BOOL;
            break;
        }
        case OP_NOT: {
            visitar_no(no->esq, escopo, funcao_atual, dentro_de_loop);
            if (no->esq->tipo_expressao != TIPO_BOOL) {
                erro_semantico("Operando de 'not' deve ser do tipo 'bool'", "");
            }
            no->tipo_expressao = TIPO_BOOL;
            break;
        }
        case OP_MENOS_UNARIO: {
            visitar_no(no->esq, escopo, funcao_atual, dentro_de_loop);
            if (no->esq->tipo_expressao != TIPO_INT) {
                erro_semantico("Operando de menos unário deve ser do tipo 'int'", "");
            }
            no->tipo_expressao = TIPO_INT;
            break;
        }

        /* --- Comandos e Estruturas --- */
        case NODO_BLOCO:
            visitar_no(no->esq, escopo, funcao_atual, dentro_de_loop);
            visitar_no(no->dir, escopo, funcao_atual, dentro_de_loop);
            break;

        case NODO_ATRIBUICAO: {
            visitar_no(no->dir, escopo, funcao_atual, dentro_de_loop);
            Tipo tipo_expressao = no->dir->tipo_expressao;

            if (tipo_expressao == TIPO_ERRO) {
                erro_semantico("Expressão do lado direito da atribuição resulta em tipo de erro", no->nome);
            }
            
            Simbolo* s = search(escopo, no->nome);

            if (s == NULL) {
                s = criarSimbolo(no->nome, tipo_expressao, 0);
                insert(escopo, no->nome, s);
                printf("[Aviso Semântico] Variável '%s' declarada implicitamente com tipo '%s'.\n", no->nome, tipo_para_string(tipo_expressao));
            } else {
                if (s->tipo != tipo_expressao) {
                    char msg[200];
                    sprintf(msg, "impossível atribuir tipo '%s' para variável '%s' que já é do tipo '%s'",
                            tipo_para_string(tipo_expressao), s->nome, tipo_para_string(s->tipo));
                    erro_semantico("Reatribuição com tipo incompatível", msg);
                }
            }
            no->tipo_expressao = TIPO_NONE;
            break;
        }

        case NODO_PRINT:
            if (no->esq) visitar_no(no->esq, escopo, funcao_atual, dentro_de_loop);
            no->tipo_expressao = TIPO_NONE;
            break;

        case NODO_IF:
            visitar_no(no->esq, escopo, funcao_atual, dentro_de_loop);
            if (no->esq->tipo_expressao != TIPO_BOOL) erro_semantico("Condição do 'if' deve ser do tipo 'bool'", "");
            visitar_no(no->dir, escopo, funcao_atual, dentro_de_loop);
            visitar_no(no->ter, escopo, funcao_atual, dentro_de_loop);
            break;

        case NODO_WHILE: {
            if (!no->esq) {
                erro_semantico("Laço 'while' construído sem condição. Erro no parser.", "");
            }
            visitar_no(no->esq, escopo, funcao_atual, dentro_de_loop);
            
            if (no->esq->tipo_expressao != TIPO_BOOL) {
                erro_semantico("A condição do 'while' deve ser um valor booleano.", "");
            }
            visitar_no(no->dir, escopo, funcao_atual, 1);
            no->tipo_expressao = TIPO_NONE;
            break;
        }

        case NODO_FOR: {
            visitar_no(no->esq, escopo, funcao_atual, dentro_de_loop);
            Tipo tipo_var_loop = TIPO_INT; 
            Simbolo* var_loop_simbolo = search(escopo, no->nome);

            if (var_loop_simbolo == NULL) {
                var_loop_simbolo = criarSimbolo(no->nome, tipo_var_loop, 0);
                insert(escopo, no->nome, var_loop_simbolo);
            } else {
                var_loop_simbolo->tipo = tipo_var_loop;
            }
            visitar_no(no->dir, escopo, funcao_atual, 1);
            no->tipo_expressao = TIPO_NONE;
            break;
        }

        case NODO_FUNC_DEF: {
            Simbolo* simbolo_funcao = search(escopo, no->nome);
            HashTable* escopo_funcao = create_table();
            if (no->esq) {
                visitar_lista_parametros(no->esq, escopo_funcao);
            }
            visitar_no(no->dir, escopo_funcao, simbolo_funcao, 0);
            free_table(escopo_funcao);
            no->tipo_expressao = TIPO_NONE;
            break;
        }
        
        case NODO_RETURN:
            if (funcao_atual == NULL) erro_semantico("Instrução 'return' fora de uma função.", "");
            if (no->esq) {
                visitar_no(no->esq, escopo, funcao_atual, dentro_de_loop);
            }
            no->tipo_expressao = TIPO_NONE;
            break;
            
        case OP_BREAK: case OP_CONTINUE:
            if (!dentro_de_loop) erro_semantico("Instrução 'break' ou 'continue' fora de um laço.", "");
            break;

        case NODO_CHAMADA_FUNC:
        case NODO_LISTA_ARGS:
            visitar_no(no->esq, escopo, funcao_atual, dentro_de_loop);
            visitar_no(no->dir, escopo, funcao_atual, dentro_de_loop);
            break;

        default:
            fprintf(stderr, "Aviso: Nó do tipo %d não tratado pelo analisador semântico.\n", no->op);
            break;
    }
}

static void visitar_lista_parametros(NoAST* no, HashTable* escopo_funcao) {
    if (!no) return;

    if (no->op == NODO_LISTA_ARGS) {
        visitar_lista_parametros(no->esq, escopo_funcao);
        visitar_lista_parametros(no->dir, escopo_funcao);
    } else if (no->op == NODO_ID) {
        if (search(escopo_funcao, no->nome) != NULL) {
            erro_semantico("Parâmetro com nome duplicado na definição da função", no->nome);
        }
        insert(escopo_funcao, no->nome, criarSimbolo(no->nome, TIPO_INT, 0));
    }
}
