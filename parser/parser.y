%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern char *yytext;
%}

%debug

%token T_IDENTIFIER T_NUMBER T_STRING
%token T_IF T_ELSE T_ELIF T_FOR T_WHILE T_DEF T_RETURN T_CLASS T_TRY T_EXCEPT T_RAISE T_FINALLY
%token T_PASS T_BREAK T_CONTINUE
%token T_ASYNC T_AWAIT
%token T_ASSERT T_AS T_FROM T_GLOBAL T_IMPORT T_IN T_IS T_LAMBDA T_NONLOCAL T_WITH T_YIELD
%token T_TRUE T_FALSE T_NONE
%token T_AND T_OR T_NOT
%token T_LPAREN T_RPAREN T_LBRACKET T_RBRACKET T_LBRACE T_RBRACE
%token T_COMMA T_COLON T_SEMICOLON
%token T_INDENT T_NEWLINE
%token T_EQUAL

%%

program:
    statements
    ;

statements:
    small_statement T_NEWLINE
    | statements small_statement T_NEWLINE
    | compound_statement
    | statements compound_statement
    ;

small_statement:
    assignment
    | flow_statement
    ;

assignment:
    T_IDENTIFIER T_EQUAL expression
    ;

flow_statement:
    T_PASS
    | T_BREAK
    | T_CONTINUE
    | T_RETURN expression
    ;

compound_statement:
    if_statement
    | while_statement
    | for_statement
    | function_def
    | class_def
    ;

if_statement:
    T_IF expression T_COLON T_NEWLINE T_INDENT statements T_NEWLINE
    ;

while_statement:
    T_WHILE expression T_COLON T_NEWLINE T_INDENT statements T_NEWLINE
    ;

for_statement:
    T_FOR T_IDENTIFIER T_IN expression T_COLON T_NEWLINE T_INDENT statements T_NEWLINE
    ;

function_def:
    T_DEF T_IDENTIFIER T_LPAREN T_RPAREN T_COLON T_NEWLINE T_INDENT statements T_NEWLINE
    ;

class_def:
    T_CLASS T_IDENTIFIER T_COLON T_NEWLINE T_INDENT statements T_NEWLINE
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
;

%%

int main() {
    yyparse();
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "Erro de sintaxe próximo de: %s (token: %s)\n", s, yytext);
    return 0;
}
