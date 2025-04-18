%{
#include <stdio.h>
#include <stdlib.h>

enum t_tokens {
    T_EQ = 256,
    T_NE,
    T_LT,
    T_LE,
    T_GT,
    T_GE,
    T_IS,
    T_IN,
    T_NOT
};

extern int yylineno;
extern char *yytext;
%}

%option noyywrap
%option yylineno

%%

[ \t]+                ;

\n+                   { }

is                  { printf("T_IS (linha %d)\n", yylineno); return T_IS; }
in                  { printf("T_IN (linha %d)\n", yylineno); return T_IN; }
not                 { printf("T_NOT (linha %d)\n", yylineno); return T_NOT; }

==                  { printf("T_EQ (linha %d)\n", yylineno); return T_EQ; }
!=                  { printf("T_NE (linha %d)\n", yylineno); return T_NE; }
<=                  { printf("T_LE (linha %d)\n", yylineno); return T_LE; }
>=                  { printf("T_GE (linha %d)\n", yylineno); return T_GE; }
<                   { printf("T_LT (linha %d)\n", yylineno); return T_LT; }
>                   { printf("T_GT (linha %d)\n", yylineno); return T_GT; }

.                     ;

%%

int main(int argc, char **argv) {
    while(yylex());
    return 0;
}
