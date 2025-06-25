#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semantico.h"

// Declaração da função recursiva que percorre a árvore.
// Ela é interna a este arquivo (static).
static void visitar_no(NoAST* no, HashTable* tabela);

// Função principal exportada
void analise_semantica(NoAST* raiz, HashTable* tabela_global) {
    if (!raiz) return;
    visitar_no(raiz, tabela_global);
}

// Função auxiliar para reportar erros
void erro_semantico(const char* mensagem, const char* detalhe) {
    fprintf(stderr, "[Erro Semântico] %s: %s\n", mensagem, detalhe);
    // Em um compilador real, você poderia contar os erros em vez de sair.
    exit(1);
}

// A função que faz todo o trabalho, percorrendo a AST
static void visitar_no(NoAST* no, HashTable* tabela) {
    if (!no) return;

    // A visita é pós-ordem para expressões: primeiro visita os filhos, depois o pai.
    // Para comandos, a ordem pode variar.

    switch(no->op) {
        // --- NÓS FOLHA (CASOS BASE DA RECURSÃO) ---
        case NODO_NUM:
            no->tipo_expressao = TIPO_INT;
            break;
        case NODO_STRING:
            no->tipo_expressao = TIPO_STRING;
            break;
        case NODO_BOOL:
            no->tipo_expressao = TIPO_BOOL;
            break;
        case NODO_NONE:
            no->tipo_expressao = TIPO_NONE;
            break;
        case NODO_ID: {
            Simbolo* s = search(tabela, no->nome);
            if (s == NULL) {
                erro_semantico("Variável não declarada", no->nome);
            }
            no->tipo_expressao = s->tipo; // O tipo do nó é o tipo do símbolo na tabela
            break;
        }

        // --- OPERADORES DE EXPRESSÃO ---
        case OP_SOMA:
        case OP_SUB:
        case OP_MUL:
        case OP_DIV: {
            visitar_no(no->esq, tabela);
            visitar_no(no->dir, tabela);
            // REGRA: Ambos os operandos devem ser inteiros.
            if (no->esq->tipo_expressao != TIPO_INT || no->dir->tipo_expressao != TIPO_INT) {
                erro_semantico("Operandos de operação aritmética devem ser do tipo 'int'", "");
            }
            no->tipo_expressao = TIPO_INT; // O resultado é 'int'
            break;
        }
        case OP_EQ:
        case OP_NE:
        case OP_LT:
        case OP_LE:
        case OP_GT:
        case OP_GE: {
            visitar_no(no->esq, tabela);
            visitar_no(no->dir, tabela);
            // REGRA: Os tipos devem ser compatíveis para comparação.
            if (no->esq->tipo_expressao != no->dir->tipo_expressao) {
                erro_semantico("Tipos incompatíveis para operação de comparação", "");
            }
            no->tipo_expressao = TIPO_BOOL; // O resultado de uma comparação é 'bool'
            break;
        }

        // --- COMANDOS ---
        case NODO_ATRIBUICAO: {
            // Primeiro, verifica se a variável do lado esquerdo foi declarada.
            Simbolo* s = search(tabela, no->nome);
            if (s == NULL) {
                erro_semantico("Variável de atribuição não declarada", no->nome);
            }
            // Agora, visita o lado direito para descobrir seu tipo.
            visitar_no(no->dir, tabela);
            // REGRA: O tipo do valor (direita) deve ser o mesmo da variável (esquerda).
            if (s->tipo != no->dir->tipo_expressao) {
                char msg[200];
                sprintf(msg, "Impossível atribuir tipo '%s' para variável '%s' do tipo '%s'",
                        tipo_para_string(no->dir->tipo_expressao),
                        s->nome,
                        tipo_para_string(s->tipo));
                erro_semantico("Incompatibilidade de tipos na atribuição", msg);
            }
            // Uma atribuição em si não tem tipo de retorno.
            no->tipo_expressao = TIPO_NONE;
            break;
        }
        case NODO_IF: {
            // Visita a condição
            visitar_no(no->esq, tabela);
            // REGRA: A condição do 'if' deve resultar em um booleano.
            if (no->esq->tipo_expressao != TIPO_BOOL) {
                erro_semantico("Condição do 'if' deve ser do tipo 'bool'", "");
            }
            // Visita os corpos do if e do else
            visitar_no(no->dir, tabela);
            visitar_no(no->ter, tabela); // 'ter' é o 'else'
            break;
        }
        case NODO_WHILE: {
            // Visita a condição
            visitar_no(no->esq, tabela);
            // REGRA: A condição do 'while' deve resultar em um booleano.
            if (no->esq->tipo_expressao != TIPO_BOOL) {
                erro_semantico("Condição do 'while' deve ser do tipo 'bool'", "");
            }
            // Visita o corpo do loop
            visitar_no(no->dir, tabela);
            break;
        }
        case NODO_BLOCO: {
            // Visita a cadeia de comandos
            visitar_no(no->esq, tabela);
            visitar_no(no->dir, tabela);
            break;
        }

        default:
            // Caso algum nó não seja tratado
            fprintf(stderr, "Aviso: Nó do tipo %d não tratado pelo analisador semântico.\n", no->op);
            break;
    }
}