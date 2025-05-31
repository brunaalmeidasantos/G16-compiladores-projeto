%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./src/hash.h"

HashTable* tabela_simbolos;

#include "parser.tab.h"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;

void yyerror(const char *s) {
    fprintf(stderr, "Erro de sintaxe na linha %d: %s\n", yylineno, s);
}

typedef struct {
    char *name;
    int type;
} Symbol;

Symbol symbol_table[1000];
int symbol_count = 0;

void add_symbol(char *name, int type) {
    if (symbol_count < 1000) {
        symbol_table[symbol_count].name = strdup(name);
        symbol_table[symbol_count].type = type;
        symbol_count++;
    }
}

void check_variable_declared(char *name) {
    if (search(tabela_simbolos, name) == NULL) {
        printf("Warning: Variável '%s' usada mas não declarada.\n", name);
    }
}
%}

%union {
    char *strval;
    int intval;
    double floatval;
}

%token <strval> ID TIPO T_STRING T_IDENTIFIER
%token <intval> T_NUMBER T_TRUE T_FALSE

%token T_PRINT T_RANGE
%token T_AND T_OR T_NOT
%token T_NONE
%token T_AS T_ASSERT T_ASYNC T_AWAIT
%token T_BREAK T_CLASS T_CONTINUE T_DEF T_DEL
%token T_ELIF T_ELSE T_EXCEPT T_FINALLY T_FOR T_FROM T_GLOBAL
%token T_IF T_IMPORT T_IN T_IS T_LAMBDA T_NONLOCAL
%token T_PASS T_RAISE T_RETURN T_TRY T_WHILE T_WITH T_YIELD
%token T_LPAREN T_RPAREN T_LBRACKET T_RBRACKET T_LBRACE T_RBRACE
%token T_COMMA T_COLON T_SEMICOLON
%token T_INDENT T_DEDENT T_NEWLINE
%token T_EQUAL T_RBAR T_LBAR T_PORCENT
%token T_PLUS T_STAR T_OPTIONAL T_PLUS_EQUAL T_MINUS_EQUAL T_MINUS
%token T_GE T_GT T_LE T_LT T_NE T_EQ
%token T_BRACE_RANGE

// Precedência (do menor para o maior)
%right T_EQUAL
%left T_OR
%left T_AND
%right T_NOT
%left T_IN T_IS
%left T_EQ T_NE T_LT T_LE T_GT T_GE
%left T_PLUS T_MINUS
%left T_STAR T_RBAR T_PORCENT
%right UMINUS
%left T_LPAREN T_RPAREN

%start program

%%


// somente Deus e o claude AI sabe como essa tabela hash ta funcionando - victor
program:
    {
        tabela_simbolos = create_table();
        printf("Iniciando análise sintática...\n");
    }
    file_input
    {
        printf("Análise sintática concluída.\n");
    }
    ;

file_input:
    /* empty */
    | file_input stmt
    | file_input NEWLINE
    | file_input declaration
    ;

NEWLINE:
    T_NEWLINE
    ;

declaration:
    TIPO ID
    {
        if (search(tabela_simbolos, $2) != NULL) {
            printf("Erro: Variável '%s' já declarada.\n", $2);
        } else {
            insert(tabela_simbolos, $2, $1);
            printf("Declarada variável: %s do tipo %s\n", $2, $1);
        }
        free($2);
        free($1);
    }
    ;

stmt:
    simple_stmt
    | compound_stmt
    ;

simple_stmt:
    small_stmt NEWLINE
    | small_stmt T_SEMICOLON NEWLINE
    ;

small_stmt:
    expr_stmt
    | print_stmt
    | flow_stmt
    ;

expr_stmt:
    testlist_star_expr
    | testlist_star_expr T_EQUAL testlist_star_expr
    {
        // Tratamento de atribuição será feito no nível semântico
        printf("Atribuição detectada\n");
    }
    ;

testlist_star_expr:
    test
    | testlist_star_expr T_COMMA test
    ;

print_stmt:
    T_PRINT T_LPAREN test T_RPAREN
    {
        printf("Comando print detectado\n");
    }
    ;

flow_stmt:
    T_BREAK
    | T_CONTINUE
    | return_stmt
    | T_PASS
    ;

return_stmt:
    T_RETURN
    | T_RETURN testlist
    ;

testlist:
    test
    | testlist T_COMMA test
    ;

test:
    or_test
    | or_test T_IF or_test T_ELSE test
    ;

or_test:
    and_test
    | or_test T_OR and_test
    ;

and_test:
    not_test
    | and_test T_AND not_test
    ;

not_test:
    T_NOT not_test
    | comparison
    ;

comparison:
    expr
    | comparison comp_op expr
    ;

comp_op:
    T_LT | T_GT | T_EQ | T_GE | T_LE | T_NE
    | T_IN | T_NOT T_IN | T_IS | T_IS T_NOT
    ;

expr:
    arith_expr
    ;

arith_expr:
    term
    | arith_expr T_PLUS term
    | arith_expr T_MINUS term
    ;

term:
    factor
    | term T_STAR factor
    | term T_RBAR factor
    | term T_PORCENT factor
    ;

factor:
    T_PLUS factor
    | T_MINUS factor %prec UMINUS
    | power
    ;

power:
    atom_expr
    ;

atom_expr:
    atom
    | atom_expr trailer
    ;

atom:
    T_IDENTIFIER
    {
        check_variable_declared($1);
        free($1);
    }
    | T_NUMBER
    | T_STRING
    {
        free($1);
    }
    | T_TRUE
    | T_FALSE
    | T_NONE
    | T_LPAREN test T_RPAREN
    | T_RANGE T_LPAREN test T_RPAREN
    ;

trailer:
    T_LPAREN arglist T_RPAREN
    | T_LBRACKET subscriptlist T_RBRACKET
    ;

subscriptlist:
    subscript
    | subscriptlist T_COMMA subscript
    ;

subscript:
    test
    ;

arglist:
    /* empty */
    | argument
    | arglist T_COMMA argument
    ;

argument:
    test
    ;

compound_stmt:
    if_stmt
    | while_stmt
    | for_stmt
    | funcdef
    ;

if_stmt:
    T_IF test T_COLON suite elif_part else_part
    ;

elif_part:
    /* empty */
    | elif_part T_ELIF test T_COLON suite
    ;

else_part:
    /* empty */
    | T_ELSE T_COLON suite
    ;

while_stmt:
    T_WHILE test T_COLON suite
    ;

for_stmt:
    T_FOR T_IDENTIFIER T_IN testlist T_COLON suite
    {
        if (search(tabela_simbolos, $2) == NULL) {
            insert(tabela_simbolos, $2, "auto");
            printf("Variável de loop '%s' autodeclarada\n", $2);
        }
        add_symbol($2, 0);
        free($2);
    }
    ;

funcdef:
    T_DEF T_IDENTIFIER T_LPAREN parameters T_RPAREN T_COLON suite
    {
        insert(tabela_simbolos, $2, "function");
        printf("Função '%s' definida\n", $2);
        add_symbol($2, 1);
        free($2);
    }
    ;

parameters:
    /* empty */
    | varargslist
    ;

varargslist:
    fpdef
    | varargslist T_COMMA fpdef
    ;

fpdef:
    T_IDENTIFIER
    {
        insert(tabela_simbolos, $1, "parameter");
        add_symbol($1, 0);
        free($1);
    }
    ;

suite:
    simple_stmt
    | NEWLINE T_INDENT stmt_list T_DEDENT
    ;

stmt_list:
    stmt
    | stmt_list stmt
    ;

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Erro ao abrir arquivo: %s\n", argv[1]);
            return 1;
        }
    }

    printf("Iniciando compilação...\n");
    int result = yyparse();

    if (result == 0) {
        printf("Compilação bem-sucedida!\n");
        printf("Total de símbolos: %d\n", symbol_count);
    } else {
        printf("Compilação falhou.\n");
    }

    if (argc > 1) {
        fclose(yyin);
    }

    // Cleanup
    if (tabela_simbolos) {
        free_table(tabela_simbolos);
    }

    // Liberar tabela de símbolos
    for (int i = 0; i < symbol_count; i++) {
        free(symbol_table[i].name);
    }

    return result;
}