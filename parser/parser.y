%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *s);
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
%token T_STAR T_PLUS T_OPTIONAL T_BRACE_RANGE
%token T_EQ T_NE T_LT T_LE T_GT T_GE T_DEL
%token T_COMMENT T_BLOCK_COMMENT
%token T_MINUS
%token T_PLUS_EQUAL T_MINUS_EQUAL
%right T_EQUAL T_PLUS_EQUAL T_MINUS_EQUAL
%left T_OR
%left T_AND
%left T_NOT
%nonassoc T_EQ T_NE T_LT T_LE T_GT T_GE
%nonassoc LOWER_THAN_ELSE
%nonassoc T_ELSE
%left T_PLUS T_MINUS
%left T_STAR
%right T_IF

%%

program: /* Trata comentario, msm que seja ignorado no parser */
    statements
    | program T_COMMENT
    | program T_BLOCK_COMMENT
    ;


statements:
    expression T_NEWLINE
    | small_statement T_NEWLINE
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
    | T_IDENTIFIER T_PLUS_EQUAL expression  %prec T_EQUAL
    | T_IDENTIFIER T_MINUS_EQUAL expression %prec T_EQUAL
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
    | T_INDENT statements T_NEWLINE /* codigos genericos */
    ;


if_statement:
    T_IF expression T_COLON suite elif_clauses else_clause
    ;

elif_clauses:
    /* vazio */
    | elif_clauses T_ELIF expression T_COLON suite
    ;

else_clause:
    /* vazio */
    | T_ELSE T_COLON suite
    ;

suite:
    T_NEWLINE T_INDENT statements T_NEWLINE
    | small_statement T_NEWLINE
    ;

while_statement:
    T_WHILE expression T_COLON T_NEWLINE T_INDENT statements T_NEWLINE
    ;

for_statement:
    T_FOR T_IDENTIFIER T_IN expression T_COLON T_NEWLINE T_INDENT statements T_NEWLINE
    ;

function_def:
    T_DEF T_IDENTIFIER T_LPAREN params T_RPAREN T_COLON T_NEWLINE T_INDENT statements T_NEWLINE
    ;

class_def:
    T_CLASS T_IDENTIFIER T_COLON T_NEWLINE T_INDENT statements T_NEWLINE
    ;

params:
    /* vazio */
    | param_list
    ;

param_list:
    T_IDENTIFIER
    | param_list T_COMMA T_IDENTIFIER
    ;

expression:
    ternary_expression
    ;

ternary_expression:
    logical_or_expression T_IF expression T_ELSE expression
    | logical_or_expression
    ;

logical_or_expression:
    logical_and_expression
    | logical_or_expression T_OR logical_and_expression
    ;

logical_and_expression:
    equality_expression
    | logical_and_expression T_AND equality_expression
    ;

equality_expression:
    relational_expression
    | equality_expression T_EQ relational_expression
    | equality_expression T_NE relational_expression
    ;

relational_expression:
    additive_expression
    | relational_expression T_LT additive_expression
    | relational_expression T_LE additive_expression
    | relational_expression T_GT additive_expression
    | relational_expression T_GE additive_expression
    ;

additive_expression:
    multiplicative_expression
    | additive_expression T_PLUS multiplicative_expression
    | additive_expression T_MINUS multiplicative_expression
    ;

multiplicative_expression:
    unary_expression
    | multiplicative_expression T_STAR unary_expression
    ;

unary_expression:
    postfix_expression
    | T_NOT unary_expression
    | T_MINUS unary_expression
    ;

postfix_expression:
    primary
    | postfix_expression T_LPAREN args T_RPAREN
    | postfix_expression T_LBRACKET expression T_RBRACKET
    ;

primary:
    T_IDENTIFIER
    | T_NUMBER
    | T_STRING
    | T_TRUE
    | T_FALSE
    | T_NONE
    | T_LPAREN expression T_RPAREN
    | T_LBRACKET list_items T_RBRACKET
    | T_LBRACE dict_items T_RBRACE
    ;

list_items: /* [1, 2, 3] */
    /* empty */
    | expression
    | list_items T_COMMA expression
    ;

dict_items: /* {"chave": valor, "outra_chave": 42} */
    /* empty */
    | expression T_COLON expression
    | dict_items T_COMMA expression T_COLON expression
    ;

args: /* funcao(arg1, arg2, arg3) */
    /* empty */
    | expression
    | args T_COMMA expression
    ;


%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Erro de sintaxe: %s (token: '%s')\n", s, yytext ? yytext : "(null)");
}