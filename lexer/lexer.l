%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum t_tokens {
    T_STRING = 256,
    T_AND,
    T_OR,
    T_NOT
};
%}

%option noyywrap

%% 

\"([^\"\\]|\\.)*\"        { printf("T_STRING: %s\n", yytext); return T_STRING; }
\'([^\'\\]|\\.)*\'        { printf("T_STRING: %s\n", yytext); return T_STRING; }

and                       { printf("T_AND\n"); return T_AND; }
or                        { printf("T_OR\n"); return T_OR; }
not                       { printf("T_NOT\n"); return T_NOT; }

.                         ;   // IGNORA OUTROS CARACTERES POR ENQUANTO, REMOVAM ESSA LINHA DEPOIS QUE OS DEMAIS TOKENS ESTIVEREM PRONTOS

%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}