%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../ast/ast.h"
#include "../src/hash.h"

// Variáveis globais
extern NoAST *ast_raiz;
extern HashTable *tabela_simbolos;

// Declarações de funções
NoAST *criarNoOp(char op, NoAST *esq, NoAST *dir);
NoAST *criarNoNum(int val);
NoAST *criarNoId(char *nome, Tipo tipo);
NoAST *criarNoString(char *valor);
NoAST *criarNoBool(int valor);
NoAST *criarNoNone();
NoAST *criarNoIf(NoAST *condicao, NoAST *corpo, NoAST *corpo_else);
NoAST *criarNoWhile(NoAST *condicao, NoAST *corpo);
NoAST *criarNoFor(char *var, NoAST *iteravel, NoAST *corpo);
NoAST *criarNoFuncao(char *nome, NoAST *parametros, NoAST *corpo);
NoAST *criarNoAtribuicao(char *nome, NoAST *valor);
void imprimirAST(NoAST *no);

int yylex();
void yyerror(const char *s);

#include "parser.tab.h"

extern FILE *yyin;
extern int yylineno;

// === OTIMIZAÇÃO: Error Recovery Melhorado ===
static int error_count = 0;
static int max_errors = 5; // Limite de erros antes de parar

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
    NoAST *node; // Corrigido para usar NoAST em vez de NoAST
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

%type <node> program file_input stmt simple_stmt small_stmt compound_stmt expr_stmt testlist_star_expr
%type <node> print_stmt flow_stmt return_stmt testlist test or_test and_test not_test comparison
%type <node> expr arith_expr comparison_expr term factor power atom_expr atom
%type <node> if_stmt optional_elif_list optional_else elif_part else_part while_stmt for_stmt funcdef suite parameters varargslist fpdef stmt_list
%type <node> maybe_indent maybe_newline declaration trailer subscriptlist subscript arglist argument
%type <strval> comp_op

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
        printf("\n--- Abstract Syntax Tree ---\n");
        imprimirAST(ast_raiz); // Imprime a AST construída
        printf("\n----------------------------\n");
    }
    ;

file_input:
    /* empty */ { $$ = NULL; }
    | file_input stmt {
        // Para uma lista de statements na raiz, você precisaria de um nó de lista na AST.
        // Por simplicidade, aqui estamos apenas pegando o último statement como a raiz
        // ou encadeando-os se tiver uma estrutura de lista de nós na AST.
        // Se a sua AST suporta uma lista de statements, adapte aqui.
        // Exemplo: $$ = adicionarStmtALista($1, $2);
        // Para este exemplo, ast_raiz irá conter o último statement processado.
        ast_raiz = $2;
        $$ = $2;
    }
    | file_input T_NEWLINE { $$ = $1; } // Ignorar novas linhas na AST
    | file_input declaration { $$ = $1; } // Declarações não geram nós na AST diretamente, mas afetam a tabela de símbolos
    ;
    
maybe_indent:
    /* vazio */ { $$ = NULL; }
    | T_INDENT maybe_indent { $$ = NULL; }
    ;

maybe_newline:
    /* vazio */ { $$ = NULL; }
    | T_NEWLINE maybe_newline { $$ = NULL; }
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
        $$ = NULL; // Declarações não produzem nós na AST diretamente
    }
    ;

stmt:
    simple_stmt { $$ = $1; }
    | compound_stmt { $$ = $1; }
    ;

simple_stmt:
    small_stmt T_NEWLINE { $$ = $1; }
    | small_stmt T_SEMICOLON T_NEWLINE { $$ = $1; }
    ;

small_stmt:
    maybe_newline expr_stmt { $$ = $2; }
    | maybe_newline print_stmt { $$ = $2; }
    | maybe_newline flow_stmt { $$ = $2; }
    ;

compound_stmt:
    maybe_newline maybe_indent if_stmt { $$ = $3; }
    | maybe_newline maybe_indent while_stmt { $$ = $3; }
    | maybe_newline maybe_indent for_stmt { $$ = $3; }
    | maybe_newline maybe_indent funcdef { $$ = $3; }
    ;

expr_stmt:
    testlist_star_expr { $$ = $1; }
    | T_IDENTIFIER T_EQUAL testlist_star_expr // Assumindo LHS é sempre um ID para simplificar
    {
        printf("Atribuição detectada\n");
        $$ = criarNoAtribuicao($1, $3);
        free($1);
    }
    ;

testlist_star_expr:
    test { $$ = $1; }
    | testlist_star_expr T_COMMA test {
        // Se você tiver um nó para lista de expressões na AST, use-o aqui.
        // Por agora, retorna apenas o último elemento.
        printf("Lista de expressão com vírgula detectada. Retornando apenas o último elemento.\n");
        $$ = $3;
    }
    ;

print_stmt:
    T_PRINT T_LPAREN test T_RPAREN
    {
        printf("Comando print detectado\n");
        // Se você quiser representar print na AST, precisará de um tipo de nó específico.
        // Por exemplo: $$ = criarNoPrint($3);
        $$ = $3; // Por enquanto, apenas passa o nó da expressão para fins de demonstração
    }
    ;

flow_stmt:
    maybe_indent T_BREAK { $$ = NULL; }
    | maybe_indent T_CONTINUE { $$ = NULL; }
    | maybe_indent T_PASS { $$ = NULL; }
    | maybe_indent return_stmt { $$ = $2; }
    ;

return_stmt:
    T_RETURN { $$ = NULL; } // Retorno vazio
    | T_RETURN testlist { $$ = $2; } // Retorna o valor da expressão
    | T_RETURN T_IDENTIFIER { $$ = criarNoId($2, TIPO_NONE); free($2); } // Tipo padrão para ID por agora
    | T_RETURN T_NUMBER { $$ = criarNoNum($2); }
    ;

testlist:
    test { $$ = $1; }
    | testlist T_COMMA test { $$ = $3; } // Simplificado: pega o último teste
    ;

test:
    or_test { $$ = $1; }
    | or_test T_IF or_test T_ELSE test {
        // Expressão condicional (Python's 'A if B else C')
        // Mapeado para um if_stmt na AST para este exemplo
        printf("Expressão condicional detectada. Mapeando para estrutura if.\n");
        $$ = criarNoIf($3, $1, $5); // condicao, corpo (if), corpo_else
    }
    ;

or_test:
    and_test { $$ = $1; }
    | or_test T_OR and_test { $$ = criarNoOp('|', $1, $3); }
    ;

and_test:
    not_test { $$ = $1; }
    | and_test T_AND not_test { $$ = criarNoOp('&', $1, $3); }
    ;

not_test:
    T_NOT not_test { $$ = criarNoOp('!', $2, NULL); } // Operador unário NOT
    | comparison { $$ = $1; }
    ;

comparison:
    expr { $$ = $1; }
    | comparison comp_op expr {
        printf("Comparação detectada: %s\n", $2);
        $$ = criarNoOp($2[0], $1, $3);
        free($2);
    }
    ;

comp_op:
    T_LT { $$ = strdup("<"); } | T_GT { $$ = strdup(">"); } | T_EQ { $$ = strdup("="); } | T_GE { $$ = strdup("G"); } | T_LE { $$ = strdup("L"); } | T_NE { $$ = strdup("N"); } // G, L, N para GE, LE, NE
    | T_IN { $$ = strdup("i"); } | T_NOT T_IN { $$ = strdup("n"); } | T_IS { $$ = strdup("s"); } | T_NOT { $$ = strdup("!"); }
    ;

expr:
    arith_expr { $$ = $1; }
    | comparison_expr { $$ = $1; }
    ;

arith_expr:
    term { $$ = $1; }
    | arith_expr T_PLUS term { $$ = criarNoOp('+', $1, $3); }
    | arith_expr T_MINUS term { $$ = criarNoOp('-', $1, $3); }
    | arith_expr T_PLUS_EQUAL term { $$ = criarNoOp('+', $1, $3); } // Tratado como adição simples para AST
    | arith_expr T_MINUS_EQUAL term { $$ = criarNoOp('-', $1, $3); } // Tratado como subtração simples para AST
    ;

comparison_expr:
    arith_expr T_EQ term { $$ = criarNoOp('=', $1, $3); }
    | arith_expr T_GT term { $$ = criarNoOp('>', $1, $3); }
    | arith_expr T_GE term { $$ = criarNoOp('G', $1, $3); }
    | arith_expr T_LT term { $$ = criarNoOp('<', $1, $3); }
    | arith_expr T_LE term { $$ = criarNoOp('L', $1, $3); }
    ;

term:
    factor { $$ = $1; }
    | term T_STAR factor { $$ = criarNoOp('*', $1, $3); }
    | term T_RBAR factor { $$ = criarNoOp('/', $1, $3); }
    | term T_PORCENT factor { $$ = criarNoOp('%', $1, $3); }
    ;

factor:
    T_PLUS factor { $$ = $2; } // Unário plus, simplesmente passa o fator
    | T_MINUS factor %prec UMINUS { $$ = criarNoOp('-', NULL, $2); } // Unário minus
    | power { $$ = $1; }
    ;

power:
    atom_expr { $$ = $1; }
    ;

atom_expr:
    atom { $$ = $1; }
    | atom_expr trailer {
        printf("Chamada de função/acesso a elemento detectado. Não representado na AST para este exemplo.\n");
        $$ = $1; // Ou crie um nó para chamada de função/acesso
    }
    ;

atom:
    T_IDENTIFIER
    {
        check_variable_declared($1);
        $$ = criarNoId($1, TIPO_NONE); // Tipo padrão para ID por agora
        free($1);
    }
    | T_NUMBER
    {
        $$ = criarNoNum($1);
    }
    | T_STRING
    {
        $$ = criarNoString($1);
        free($1);
    }
    | T_TRUE
    {
        $$ = criarNoBool(1);
    }
    | T_FALSE
    {
        $$ = criarNoBool(0);
    }
    | T_NONE
    {
        $$ = criarNoNone();
    }
    | T_LPAREN test T_RPAREN { $$ = $2; } 
    | T_RANGE T_LPAREN test T_RPAREN {
        printf("Função range detectada. Não representado na AST para este exemplo.\n");
        $$ = $3;
    }
    | maybe_indent T_IDENTIFIER T_EQUAL arith_expr
    {
        printf("Atribuição embutida detectada.\n");
        $$ = criarNoAtribuicao($2, $4);
        free($2);
    }
    ;

trailer:
    T_LPAREN arglist T_RPAREN { $$ = $2; }
    | T_LBRACKET subscriptlist T_RBRACKET { $$ = $2; }
    ;

subscriptlist:
    subscript { $$ = $1; }
    | subscriptlist T_COMMA subscript { $$ = $3; }
    ;

subscript:
    test { $$ = $1; }
    ;

arglist:
    /* empty */ { $$ = NULL; }
    | argument { $$ = $1; }
    | arglist T_COMMA argument { $$ = $3; }
    ;

argument:
    test { $$ = $1; }
    ;
    
if_stmt:
    T_IF expr T_COLON T_NEWLINE maybe_indent suite optional_elif_list optional_else
    {
        printf("If statement detectado\n");
        $$ = criarNoIf($2, $6, $7);
    }
    ;
    
optional_elif_list:
    /* vazio */ { $$ = NULL; }
    | optional_elif_list T_ELIF expr T_COLON T_NEWLINE maybe_indent suite
    {
        printf("Elif detectado. Simplificando a estrutura da AST.\n");
        $$ = criarNoIf($3, $7, NULL);
    }
;

optional_else:
    /* vazio */ { $$ = NULL; }
    | T_ELSE T_COLON T_NEWLINE maybe_indent suite
    {
        printf("Else detectado\n");
        $$ = $5;
    }
;

elif_part:
    /* empty */ { $$ = NULL; }
    | elif_part T_ELIF test T_COLON suite { $$ = NULL; }
    ;

else_part:
    /* empty */ { $$ = NULL; }
    | T_ELSE T_COLON suite { $$ = NULL; }
    ;

while_stmt:
    T_WHILE expr T_COLON T_NEWLINE maybe_indent suite
    {
        printf("While statement detectado\n");
        $$ = criarNoWhile($2, $6);
    }
    ;

for_stmt:
    T_FOR T_IDENTIFIER T_IN expr T_COLON T_NEWLINE maybe_indent suite
    {
        if (search(tabela_simbolos, $2) == NULL) {
            insert(tabela_simbolos, $2, "auto");
            printf("Variável de loop '%s' autodeclarada\n", $2);
        }
        add_symbol($2, 0);
        printf("For statement detectado\n");
        $$ = criarNoFor($2, $4, $7); // var, iteravel, corpo
        free($2);
    }
    ;

suite:
    maybe_indent stmt { $$ = $2; }
    | maybe_indent simple_stmt { $$ = $2; }
    | maybe_indent compound_stmt { $$ = $2; }
    | /* empty */ { $$ = NULL; }
    ;

funcdef:
    T_DEF T_IDENTIFIER T_LPAREN parameters T_RPAREN T_COLON T_NEWLINE suite
    {
        insert(tabela_simbolos, $2, "function");
        printf("Função '%s' definida\n", $2);
        add_symbol($2, 1);
        $$ = criarNoFuncao($2, $4, NULL);
        free($2);
    }
    ;

parameters:
    /* empty */ { $$ = NULL; }
    | varargslist { $$ = $1; }
    ;

varargslist:
    fpdef { $$ = $1; }
    | varargslist T_COMMA fpdef {
        printf("Lista de parâmetros detectada. Simplificando a AST.\n");
        $$ = $3;
    }
    ;

fpdef:
    T_IDENTIFIER
    {
        insert(tabela_simbolos, $1, "parameter");
        add_symbol($1, 0);
        $$ = criarNoId($1, TIPO_NONE);
        free($1);
    }
    ;

stmt_list:
    stmt { $$ = $1; }
    | stmt_list stmt {
        printf("Lista de statements detectada. Simplificando a AST.\n");
        $$ = $2;
    }
    ;

%%

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
    int result = yyparse();

    if (result == 0) {
        printf("Compilação bem-sucedida!\n");
        printf("Total de símbolos: %d\n", symbol_count);
    } else {
        printf("Compilação falhou.\n");
    }

    // === OTIMIZAÇÃO: Cleanup mais eficiente ===
    if (yyin && yyin != stdin) { // Fechar apenas se não for stdin
        fclose(yyin);
    }

    if (tabela_simbolos) {
        free_table(tabela_simbolos);
    }
    for (int i = 0; i < symbol_count; i++) {
        free(symbol_table[i].name);
    }   

    return result;
}