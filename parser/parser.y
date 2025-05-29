%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "parser.tab.h"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;

void yyerror(const char *s) {
    fprintf(stderr, "Erro de sintaxe\n");
}

typedef struct {
    char *name;
    int type;
} Symbol;

Symbol symbol_table[1000];
int symbol_count = 0;

void add_symbol(char *name, int type) {
    symbol_table[symbol_count].name = strdup(name);
    symbol_table[symbol_count].type = type;
    symbol_count++;
}
%}

%union {
    char *strval;
    int intval;
    double floatval;
}

%token T_PRINT T_RANGE
%token T_STRING
%token T_AND T_OR T_NOT
%token T_FALSE T_NONE T_TRUE
%token T_AS T_ASSERT T_ASYNC T_AWAIT
%token T_BREAK T_CLASS T_CONTINUE T_DEF T_DEL
%token T_ELIF T_ELSE T_EXCEPT T_FINALLY T_FOR T_FROM T_GLOBAL
%token T_IF T_IMPORT T_IN T_IS T_LAMBDA T_NONLOCAL
%token T_PASS T_RAISE T_RETURN T_TRY T_WHILE T_WITH T_YIELD
%token T_IDENTIFIER
%token T_LPAREN T_RPAREN T_LBRACKET T_RBRACKET T_LBRACE T_RBRACE
%token T_COMMA T_COLON T_SEMICOLON
%token T_INDENT T_NEWLINE
%token T_NUMBER
%token T_EQUAL T_RBAR T_LBAR T_PORCENT
%token T_PLUS T_STAR T_OPTIONAL T_PLUS_EQUAL T_MINUS_EQUAL T_MINUS
%token T_GE T_GT T_LE T_LT T_NE T_EQ
%token T_BRACE_RANGE

%type <intval> T_NUMBER T_TRUE T_FALSE
%type <strval> T_STRING T_IDENTIFIER

%nonassoc T_LPAREN T_RPAREN
%nonassoc T_LBRACKET T_RBRACKET
%nonassoc T_LBRACE T_RBRACE
%nonassoc T_IS
%nonassoc T_IN
%right T_EQUAL

%start program

%%

maybe_newline:
      /* vazio */
    | T_NEWLINE
    ;

program:
    statements
    ;

statements:
    /* empty */
    | statements statement
    ;

statement:
      simple_statement
    | compound_statement
    ;

simple_statement:
      expression maybe_newline
    | assignment maybe_newline
    | T_RETURN expression maybe_newline
    | T_RETURN maybe_newline
    | T_PASS maybe_newline
    | T_BREAK maybe_newline
    | T_CONTINUE maybe_newline
    | T_PRINT T_LPAREN expression T_RPAREN maybe_newline
    ;

assignment:
    T_IDENTIFIER T_EQUAL expression
    {
        add_symbol($1, 0);
        free($1);
    }
    | T_IDENTIFIER ',' T_IDENTIFIER T_EQUAL expression ',' expression
    {
        add_symbol($1, 0);
        add_symbol($3, 0);
        free($1);
        free($3);
    }
    ;

expression:
      T_NUMBER
    | T_STRING
    | T_IDENTIFIER
    | T_TRUE
    | T_FALSE
    | T_NONE
    | expression T_AND expression
    | expression T_OR expression
    | T_NOT expression
    | expression T_PLUS expression
    | expression T_MINUS expression
    | expression T_STAR expression
    | expression T_RBAR expression
    | expression T_PORCENT expression
    | expression T_GT expression
    | expression T_LT expression
    | expression T_IS expression
    | expression T_EQ expression
    | T_LPAREN expression T_RPAREN
    | T_IDENTIFIER T_LPAREN arglist T_RPAREN
    | T_RANGE T_LPAREN expression T_RPAREN
    ;

arglist:
    /* empty */
    | expression
    | arglist T_COMMA expression
    ;

compound_statement:
      if_statement
    | while_statement
    | for_statement
    | function_def
    ;

if_statement:
    T_IF expression T_COLON T_NEWLINE suite
    | T_IF expression T_COLON suite T_NEWLINE T_ELSE T_COLON T_NEWLINE suite T_NEWLINE
    | T_IF expression T_COLON suite T_NEWLINE T_ELIF expression T_COLON suite T_NEWLINE
    ;

suite:
    T_INDENT statements
    | simple_statement
    ;

while_statement:
    T_WHILE expression T_COLON suite
    ;

for_statement:
    T_FOR T_IDENTIFIER T_IN expression T_COLON suite
    ;

function_def:
    T_DEF T_IDENTIFIER T_LPAREN parameters T_RPAREN T_COLON maybe_newline suite
    ;

parameters:
    /* empty */
    | T_IDENTIFIER
    | parameters T_COMMA T_IDENTIFIER
    ;

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Erro ao abrir arquivo\n");
            return 1;
        }
    }

    int result = yyparse();

    if (argc > 1) {
        fclose(yyin);
    }

    return result;
}