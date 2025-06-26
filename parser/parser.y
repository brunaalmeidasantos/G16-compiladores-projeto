%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../src/globals.h"
#include "../semantico/semantico.h"

int yylex();
void yyerror(const char *s);

extern FILE *yyin;
extern int yylineno;
%}

%union {
    char *strval;
    int intval;
    float floatval;
    NoAST *node;
}

%token <strval> ID TIPO T_STRING T_IDENTIFIER
%token <intval> T_TRUE T_FALSE
%token <floatval> T_FLOAT_NUMBER
%token <intval> T_NUMBER

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
%token T_INDENT T_NEWLINE T_DEDENT
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

%nonassoc T_LOWER_THAN_ELSE
%nonassoc T_ELSE

%type <node> program file_input stmt simple_stmt small_stmt compound_stmt expr_stmt
%type <node> test or_test and_test not_test comparison
%type <node> expr arith_expr term factor power atom_expr atom
%type <node> if_stmt suite while_stmt for_stmt funcdef parameters param_list
%type <node> print_stmt flow_stmt return_stmt
%type <node> trailer arglist argument
%type <node> stmt_list declaration
%type <node> maybe_indent maybe_newline
%type <strval> comp_op

%start program

%%

program:
    {
        tabela_simbolos_global = create_table();
        printf("Iniciando análise sintática...\n");
    }
    file_input
    {
        printf("Análise sintática concluída.\n");
        ast_raiz = $2;
        if (ast_raiz) {
            printf("\nIniciando análise semântica...\n");
            analise_semantica(ast_raiz, tabela_simbolos_global);
            printf("Análise semântica concluída.\n");
        } else {
            printf("Nenhuma AST foi gerada.\n");
        }
    }
    ;

file_input:
    /* empty */ { $$ = NULL; }
    | file_input stmt { $$ = criarNoBloco($1, $2); }
    | file_input T_NEWLINE { $$ = $1; }
    | file_input declaration { $$ = $1; }
    ;

maybe_indent:
    /* vazio */ { $$ = NULL; }
    | T_INDENT maybe_indent { $$ = NULL; }
    ;

maybe_dedent:
    /* vazio */
    | T_DEDENT maybe_dedent
    ;

maybe_newline:
    /* vazio */ { $$ = NULL; }
    | T_NEWLINE maybe_newline { $$ = NULL; }
    ;

declaration:
    maybe_newline TIPO ID
    {
        Simbolo* simbolo_existente = search(tabela_simbolos_global, $2);
        if (simbolo_existente != NULL) {
            char error_msg[100];
            sprintf(error_msg, "Variável '%s' já declarada", $2);
            yyerror(error_msg);
        } else {
            Tipo tipo = tipo_from_string($2);
            Simbolo* novo_simbolo = criarSimbolo($2, tipo, 0);
            insert(tabela_simbolos_global, $2, novo_simbolo);
            printf("Declarada variável: %s do tipo %s\n", $2, $2);
        }
        free($1);
        free($2);
        $$ = NULL;
    }
    ;

stmt: simple_stmt maybe_newline { $$ = $1; } | compound_stmt maybe_newline maybe_indent { $$ = $1; };

simple_stmt: small_stmt maybe_newline { $$ = $1; };

small_stmt:
    maybe_newline maybe_indent expr_stmt { $$ = $3; }
    | maybe_newline maybe_indent print_stmt { $$ = $3; }
    | maybe_newline maybe_indent flow_stmt T_NEWLINE T_DEDENT { $$ = $3; }
    ;

compound_stmt:
    maybe_newline maybe_indent if_stmt T_NEWLINE T_DEDENT { $$ = $3; }
    | maybe_newline maybe_indent while_stmt T_NEWLINE T_DEDENT { $$ = $3; }
    | maybe_newline maybe_indent for_stmt T_NEWLINE T_DEDENT { $$ = $3; }
    | maybe_newline maybe_indent funcdef T_NEWLINE T_DEDENT { $$ = $3; }
    ;

expr_stmt:
    T_IDENTIFIER T_EQUAL test { $$ = criarNoAtribuicao($1, $3); free($1); }
    | test { $$ = $1; }
    | T_IDENTIFIER T_EQUAL expr { $$ = criarNoAtribuicao($1, $3); free($1); }
    ;

flow_stmt:
    maybe_dedent maybe_newline T_BREAK { $$ = criarNoFlow(T_BREAK); }
    | maybe_dedent maybe_newline T_CONTINUE { $$ = criarNoFlow(T_CONTINUE); }
    | maybe_dedent maybe_newline T_PASS { $$ = NULL; } // Pass não gera nó
    | maybe_dedent maybe_newline return_stmt { $$ = $3; }
    ;

test:
    or_test { $$ = $1; }
    | or_test T_IF or_test T_ELSE test { $$ = criarNoIf($3, $1, $5); }
    ;

or_test: and_test { $$ = $1; } | or_test T_OR and_test { $$ = criarNoOp(OP_OR, $1, $3); };
and_test: not_test { $$ = $1; } | and_test T_AND not_test { $$ = criarNoOp(OP_AND, $1, $3); };
not_test: T_NOT not_test { $$ = criarNoOp(OP_NOT, $2, NULL); } | comparison { $$ = $1; };

print_stmt:
    T_PRINT T_LPAREN test T_RPAREN { $$ = criarNoPrint($3); }
    ;

comparison:
    expr { $$ = $1; }
    | comparison comp_op expr { $$ = criarNoOp(op_from_string($2), $1, $3); free($2); }
    ;

comp_op:
    T_LT { $$ = strdup("<"); } | T_GT { $$ = strdup(">"); } | T_EQ { $$ = strdup("=="); }
    | T_GE { $$ = strdup(">="); } | T_LE { $$ = strdup("<="); } | T_NE { $$ = strdup("!="); }
    ;

expr: arith_expr { $$ = $1; };
arith_expr: term { $$ = $1; } | arith_expr T_PLUS term { $$ = criarNoOp(OP_SOMA, $1, $3); } | arith_expr T_MINUS term { $$ = criarNoOp(OP_SUB, $1, $3); };
term: factor { $$ = $1; } | term T_STAR factor { $$ = criarNoOp(OP_MUL, $1, $3); } | term T_RBAR factor { $$ = criarNoOp(OP_DIV, $1, $3); };
factor: power { $$ = $1; } | T_MINUS factor %prec UMINUS { $$ = criarNoOp(OP_MENOS_UNARIO, $2, NULL); };
power: atom_expr { $$ = $1; };

atom_expr:
    atom { $$ = $1; }
    | atom_expr trailer {
        $2->esq = $1;
        $$ = $2;
     }
    ;

atom:
    T_IDENTIFIER { $$ = criarNoId($1); free($1); }
    | T_NUMBER { $$ = criarNoNum($1); }
    | T_FLOAT_NUMBER { $$ = criarNoFloat($1); }
    | T_STRING { $$ = criarNoString($1); free($1); }
    | T_TRUE   { $$ = criarNoBool(1); }
    | T_FALSE  { $$ = criarNoBool(0); }
    | T_NONE   { $$ = criarNoNone(); }
    | T_LPAREN test T_RPAREN { $$ = $2; }
    ;

trailer: T_LPAREN arglist T_RPAREN { $$ = criarNoChamadaFunc($2); };

arglist:
    /* empty */ { $$ = NULL; }
    | argument { $$ = $1; }
    | arglist T_COMMA argument { $$ = criarNoListaArgs($1, $3); }
    ;

argument: test { $$ = $1; };

if_stmt:
    T_IF test T_COLON T_NEWLINE suite %prec T_LOWER_THAN_ELSE { $$ = criarNoIf($2, $5, NULL); }
    | T_IF test T_COLON T_NEWLINE suite T_ELSE suite { $$ = criarNoIf($2, $5, $7); }
    ;

while_stmt: T_WHILE test T_COLON T_NEWLINE T_INDENT suite { $$ = criarNoWhile($2, $6); };

for_stmt:
    maybe_newline T_FOR T_IDENTIFIER T_IN T_RANGE test T_COLON T_NEWLINE suite
    {
        if (search(tabela_simbolos_global, $3) == NULL) {
            insert(tabela_simbolos_global, $3, criarSimbolo($3, TIPO_INT, 0));
        }
        $$ = criarNoFor($3, $6, $9);
        free($3);
    }
    ;

funcdef:
    T_DEF T_IDENTIFIER T_LPAREN parameters T_RPAREN T_COLON T_NEWLINE T_INDENT suite
    {
        if (search(tabela_simbolos_global, $2) != NULL) {
            yyerror("Erro Semântico: Função ou variável com este nome já declarada.");
        } else {
            insert(tabela_simbolos_global, $2, criarSimbolo($2, TIPO_FUNCAO, 1));
        }
        $$ = criarNoFuncao($2, $4, $9);
        free($2);
    }
    ;

parameters:
    /* empty */ { $$ = NULL; }
    | param_list { $$ = $1; }
    ;

param_list:
    T_IDENTIFIER { $$ = criarNoId($1); free($1); }
    | param_list T_COMMA T_IDENTIFIER { $$ = criarNoListaArgs($1, criarNoId($3)); free($3); }
    ;

return_stmt:
    T_RETURN { $$ = criarNoReturn(NULL); }
    | T_RETURN test { $$ = criarNoReturn($2); }
    ;

suite:
    maybe_newline maybe_indent stmt_list { $$ = $3; }
    | maybe_newline maybe_indent flow_stmt { $$ = $3; }
    | maybe_newline maybe_indent print_stmt { $$ = $3; }
    | maybe_newline maybe_indent expr_stmt { $$ = $3; }
    | maybe_newline maybe_indent suite { $$ = $3; }
    ;

stmt_list:
    stmt { $$ = $1; }
    | stmt_list stmt { $$ = criarNoBloco($1, $2); }
    ;

%%