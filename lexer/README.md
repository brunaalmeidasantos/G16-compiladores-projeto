# Analisador Léxico

## O que é?

O [analisador léxico](./lexer.l), por vezes chamado de *scanner*, é a primeira etapa de um compilador ou interpretador. Ele lê o código-fonte como texto bruto e o divide em unidades chamadas de tokens. Os tokens, por sua vez, são grupos de caracteres que têm um significado na linguagem. Exemplos de tokens são operadores (+, =, ==).

## Como funciona?

O [analisador léxico](./lexer.l) criado para esse trabalho funciona conforme se segue:

1. Lê o código fonte, caractere por caractere;
2. Ignora fatores irrelevantes, como comentários;
3. Agrupa os caracteres conforme os tokens definidos por regras elaboradas com o uso de regex;
4. Realiza a classificação de cada token (T_IDENTIFIER, T_NUMBER, T_STRING, e etc);
5. Entrega os tokens para o [analisador sintático](../parser/parser.y).

## Exemplo

Código fonte:

```py
if x == 10:
    print("Olá Mundo!")
```

Tokens gerados:
```bash
T_IF
T_IDENTIFIER: x
T_EQ
T_NUMBER: 10
T_COLON
T_PRINT
T_LPAREN
T_STRING: "Olá Mundo!"
T_RPAREN
```

## Explicando o código

O trecho abaixo está entre ```%{}%```, indicando que é um código C que deve ser inserido diretamente no início do arquivo C gerado pelo *flex*. Se trata de um bloco de configurações e definições iniciais, que pode conter inclusão de bibliotecas, declaração de variáveis globais, funções auxiliares, constantes e outros.

No caso desse código em específico, incluímos bibliotecas, declaramos a variável ```line_num``` (linha inicial lida) e duas funções para printar os tokens que o programa irá encontrar. A função ```print_simple_token()``` imprime tokens sem valor associado (ex: ```T_IF```). Já a função ```print_token()``` imprime tokens com valor associado (ex: ```T_NUMBER: 10```).

```c
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

int line_num = 1;

void print_token(const char* token_name, const char* value) {
    printf("%s: %s\n", token_name, value);
}

void print_simple_token(const char* token_name) {
    printf("%s\n", token_name);
}
%}
```

A linha de código abaixo desativa a necessidade de definir ```yywrap()``` e desativa funções padrão de entrada e saída, útil ao realizar a integração com o *parser*.

```flex
%option noyywrap nounput noinput
```

O restante do código define as regras por meio de regex para identificar cada token. Cada regex está seguida por ```return``` *nome do token* e uma das funções para imprimir o token, citadas no início dessa seção.

```flex
"="                        { print_simple_token("T_EQUAL"); return T_EQUAL; }
"+="                       { print_simple_token("T_PLUS_EQUAL"); return T_PLUS_EQUAL; }
"-="                       { print_simple_token("T_MINUS_EQUAL"); return T_MINUS_EQUAL; }
"=="                       { print_simple_token("T_EQ"); return T_EQ; }
"!="                       { print_simple_token("T_NE"); return T_NE; }

[...]

[0-9]+(\.[0-9]+)?          { yylval.intval = atoi(yytext); 
                             print_token("T_NUMBER", yytext); 
                             return T_NUMBER; }
                             
[...]
```