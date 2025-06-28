#include <stdio.h>
#include<stdlib.h>
#include<string.h>
#include "globals.h" // Inclui os protótipos e declarações extern

#include "../ast/ast.h" // Depende da definição da sua AST
#include "../intermediario/gerador_ci.h"
#include "../final/codfinal.h"

// =================================================================
// DEFINIÇÃO DAS VARIÁVEIS GLOBAIS
// Este é o único lugar onde a memória para elas é alocada.
// =================================================================

// CORREÇÃO: Padronizado para o nome usado no parser.
HashTable *tabela_simbolos_global = NULL;
NoAST *ast_raiz = NULL;

// =================================================================
// DEFINIÇÃO DA FUNÇÃO DE ERRO
// =================================================================

// A função yyerror é chamada pelo parser em caso de erro de sintaxe.
extern int yylineno; // Acessa o número da linha do lexer.
extern FILE *yyin;
extern int yyparse(void);
void yyerror(const char *s) {
    fprintf(stderr, "[Erro de Sintaxe] Linha %d: %s\n", yylineno, s);
}

// =================================================================
// FUNÇÃO MAIN - PONTO DE ENTRADA PRINCIPAL
// =================================================================
int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Erro ao abrir arquivo: %s\n", argv[1]);
            return 1;
        }
    } else {
        yyin = stdin;
    }

    printf("Iniciando compilação...\n");
    // yyparse() é a função gerada pelo Bison que inicia a análise.
    int result = yyparse();

    if (result == 0) {
        printf("\nCompilação bem-sucedida!\n");
        if (ast_raiz != NULL) {
            printf("\n=== CÓDIGO INTERMEDIÁRIO ===\n");
            
            // Gera o nome do arquivo de saída (.ir = intermediate representation)
            char nome_arquivo_ci[256];
            if (argc > 1) {
                // Remove a extensão do arquivo original e adiciona .ir
                strcpy(nome_arquivo_ci, argv[1]);
                char *ponto = strrchr(nome_arquivo_ci, '.');
                if (ponto) *ponto = '\0';
                strcat(nome_arquivo_ci, ".ir");
            } else {
                strcpy(nome_arquivo_ci, "output.ir");
            }
            
            // Redireciona stdout para o arquivo
            FILE *arquivo_ci = fopen(nome_arquivo_ci, "w");
            if (arquivo_ci) {
                FILE *stdout_original = stdout;
                stdout = arquivo_ci;
                
                gerar_codigo_intermediario(ast_raiz);
                
                // Restaura stdout e fecha arquivo
                stdout = stdout_original;
                fclose(arquivo_ci);
                
                printf("Código intermediário salvo em: %s\n", nome_arquivo_ci);
                
                // Também mostra na tela
                printf("\nConteúdo do código intermediário:\n");
                gerar_codigo_intermediario(ast_raiz);
            } else {
                printf("Erro ao criar arquivo de código intermediário.\n");
                // Se não conseguir criar arquivo, só mostra na tela
                gerar_codigo_intermediario(ast_raiz);
            }
            
            printf("=== FIM DO CÓDIGO INTERMEDIÁRIO ===\n");

            printf("FASE 4: Geracao de Codigo Final C a partir do CI...\n");
            gerar_final_de_ci(nome_arquivo_ci, "saida.c");
            
        } else {
            printf("Aviso: AST não foi gerada.\n");
        }
    } else {
        printf("\nCompilação falhou com %d erro(s) de sintaxe.\n", result);
    }

    if (yyin && yyin != stdin) {
        fclose(yyin);
    }
    if (tabela_simbolos_global) {
        free_table(tabela_simbolos_global);
    }
    // free_ast(ast_raiz); // Futuramente, implementar a liberação da AST

    return result;
}

// CODIGO INTERMEDIARIO
    