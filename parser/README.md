# Analisador Sintático

## O que é?

O analisador sintático (ou *parser*) é a segunda etapa de um compilador ou interpretador. Ele recebe os tokens produzidos pelo [analisador léxico](../lexer/lexer.l) e verifica se esses tokens formam estruturas válidas de acordo com a gramática da linguagem (Python3).

## Como funciona?

O [analisador sintático](./parser.y) criado para esse trabalho funciona conforme se segue:

1. Recebe uma sequência de tokens (como T_IF, T_LPAREN, T_IDENTIFIER, T_RPAREN, T_COLON);
2. Compara essa sequência com as regras da [gramática](../docs/gramatica.md);
3. Verifica se a estrutura é válida.;
4. Cria uma árvore sintática (*AST – Abstract Syntax Tree*) que representa a estrutura do código;
5. Reporta os primeiros 5 erros de sintaxe encontrados. Caso o número de erros encontrados seja maior que o limite máximo definido, para a compilação.

## Exemplo

Código fonte sintaticamente correto:

```py
if x == 10:
    print("Olá Mundo!")
```

Código fonte sintaticamente incorreto:

```py
if x == 10
    print(
    "Olá mundo!"
    )
```

Exemplo de tokens do [analisador léxico](../lexer/lexer.l):

```bash
T_IF
T_IDENTIFIER: x
T_GT
T_NUMBER: 10
T_COLON
T_PRINT
T_LPAREN
T_STRING: "x é maior que 10"
T_RPAREN
```

O [analisador sintático](./parser.y) irá interpretar os tokens acima como:

```text
if_stmt:
  expr: x > 10
  suite:
    print_stmt: print("x é maior que 10")
```

## Explicando o código

Tudo entre ```%{ ... %}``` é código C que será inserido no início do código gerado por *Bison*. Serve para definir variáveis, funções auxiliares e incluir bibliotecas.

Nesse código, após a inclusão de bibliotecas e do parser no cabeçalho gerado pelo *Bison*, há a declaração de um ponteiro para a tabela *hash*, responsável por armazenar variáveis, funções e etc. Em seguida, fazemos declarações externas para ```yylex()```, gerada pelo analisador léxico; ```yyparse()```, gerada pelo *Bison*; ```*yyin```, o ponteiro para o arquivo de entrada; e, por fim, ```yylineno```, o número da linha atual.

Abaixo das declarações das variáveis externas, há a função ```yyerror()```, chamada automaticamente pelo *Bison* quando ocorre erro de sintaxe. A função foi otimizada para contar a quantidade de erros e possui como limite 5. Caso hajam mais de 5 erros, a compilação é abortada.

Para finalizar o cabeçalho do [parser.y](./parser.y), o código conta com uma estrutura para armazenar os símbolos. A tabela de símbolos é simples e é feita em forma de vetor, que deverá guardar até 1000 identificadores, como variáveis, com seus nomes e tipos. A função ```add_symbol()``` trata da inserção dos símbolos na tabela e a função ```check_variable_declared()``` verifica se a variável foi declarada na tabela de símbolos. Caso uma variável não tenha sido declarada, a função retorna um aviso, mas não impede que a compilação continue.

```c
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

static int error_count = 0;
static int max_errors = 5;

void yyerror(const char *s) {
    error_count++;

    if (error_count >= max_errors) {
        fprintf(stderr, "Muitos erros encontrados. Parando compilação.\n");
        exit(1);
    }

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
```

O código abaixo se refere ao ```%union```, que define um tipo unificado de valor chamado *YYSTYPE*. Cada token ou regra que carrega um valor precisa dizer qual campo desse *union* está sendo usado. Assim, o *Bison* pode associar um valor semântico a cada token ou regra (nome de um identificador, valor de um número, etc.).

```parser
%union {
    char *strval;
    int intval;
    double floatval;
}
```

Os tokens são declarados conforme o trecho de código abaixo, tendo em vista que tokens como ```T_NUMBER``` devem possuir valor associado. A associação desse valor é feita, tendo como exemplo o token ```T_NUMBER```, passando um ```<intval>```. O mesmo pode ocorrer para os demais campos presentes no ```%union```. Após a declaração dos tokens, há a definição da precendência, ou seja, define a ordem em que os operadores serão avaliados pelo compilador. Como exemplo, tenha em mente ```a + b * c```. O compilador deverá processar ```b * c```, antes de realizar a soma com ```a```.

```parser
%token <strval> ID TIPO T_STRING T_IDENTIFIER
%token <intval> T_NUMBER T_TRUE T_FALSE

%token T_PRINT T_RANGE
%token T_AND T_OR T_NOT

[...]

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

[...]
```

O restante do código define as regras gramaticais das estruturas mais comuns da linguagem Python por meio da correta ordenação dos tokens identificados pelo [analisador léxico](../lexer/lexer.l). O trecho de código abaixo apresenta a correta ordenação de tokens necessária para lidar com comparações em Python 3.

```parser
[...]

comparison:
    expr
    | comparison comp_op expr
    ;

comp_op:
    T_LT | T_GT | T_EQ | T_GE | T_LE | T_NE
    | T_IN | T_NOT T_IN | T_IS | T_NOT
    ;

expr:
    arith_expr
    | comparison_expr
    ;

arith_expr:
    term
    | arith_expr T_PLUS term
    | arith_expr T_MINUS term
    | arith_expr T_PLUS_EQUAL term
    | arith_expr T_MINUS_EQUAL term
    ;  

[...]
```