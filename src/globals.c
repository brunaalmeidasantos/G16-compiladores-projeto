#include <stdio.h>
#include "globals.h" // Inclui os protótipos e declarações extern

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
