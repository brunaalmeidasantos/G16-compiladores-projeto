%{
#include <stdio.h>
#include <stdlib.h>

enum t_tokens {
    T_COMMENT = 256,
    T_BLOCK_COMMENT,
    T_STAR,
    T_PLUS,
    T_OPTIONAL,
    T_BRACE_RANGE
};
%}

%option noyywrap

DIGIT      [0-9]+
SPACE      [ \t\n]*


%%

\/\/[^\n]*                 { printf("T_COMMENT: %s\n", yytext); return T_COMMENT; }

\/\*([^*]|\*+[^*/])*\*+\/  { printf("T_BLOCK_COMMENT: %s\n", yytext); return T_BLOCK_COMMENT; }

\*                        { printf("T_STAR\n"); return T_STAR; }
\+                        { printf("T_PLUS\n"); return T_PLUS; }
\?                        { printf("T_OPTIONAL\n"); return T_OPTIONAL; }

\{[0-9]+\}                { printf("T_BRACE_RANGE: %s\n", yytext); return T_BRACE_RANGE; }
\{[0-9]+,\}               { printf("T_BRACE_RANGE: %s\n", yytext); return T_BRACE_RANGE; }
\{[0-9]+,[0-9]+\}         { printf("T_BRACE_RANGE: %s\n", yytext); return T_BRACE_RANGE; }

.                         ; // Ignora qualquer outro caractere por enquanto

%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}
