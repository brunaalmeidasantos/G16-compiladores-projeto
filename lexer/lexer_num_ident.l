%{
#include <stdio.h>
%}

%option noyywrap

DIGITO      [0-9]
LETRA       [a-zA-Z]
ID          {LETRA}({LETRA}|{DIGITO}|_)*

%%

{DIGITO}+("."{DIGITO}+)?    { printf("Número: %s\n", yytext); }
{ID}                        { printf("Identificador: %s\n", yytext); }
[ \t\n]+                    { /* Ignorar espaços e quebras de linha */ }
.                           { printf("Outro: %s\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}
