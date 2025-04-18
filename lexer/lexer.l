%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum t_tokens {
    T_STRING = 256,
    // Operadores lógicos
    T_AND,
    T_OR,
    T_NOT,
    // palavras-chave
    T_FALSE,
    T_NONE,
    T_TRUE,
    T_AS,
    T_ASSERT,
    T_ASYNC,
    T_AWAIT,
    T_BREAK,
    T_CLASS,
    T_CONTINUE,
    T_DEF,
    T_DEL,
    T_ELIF,
    T_ELSE,
    T_EXCEPT,
    T_FINALLY,
    T_FOR,
    T_FROM,
    T_GLOBAL,
    T_IF,
    T_IMPORT,
    T_IN,
    T_IS,
    T_LAMBDA,
    T_NONLOCAL,
    T_PASS,
    T_RAISE,
    T_RETURN,
    T_TRY,
    T_WHILE,
    T_WITH,
    T_YIELD,
    // Identificador
    T_IDENTIFIER
};
%}

%option noyywrap

%% 

\"([^\"\\]|\\.)*\"        { printf("T_STRING: %s\n", yytext); return T_STRING; }
\'([^\'\\]|\\.)*\'        { printf("T_STRING: %s\n", yytext); return T_STRING; }

and                       { printf("T_AND\n"); return T_AND; }
or                        { printf("T_OR\n"); return T_OR; }
not                       { printf("T_NOT\n"); return T_NOT; }


False                     { printf("T_FALSE\n"); return T_FALSE; }
None                      { printf("T_NONE\n"); return T_NONE; }
True                      { printf("T_TRUE\n"); return T_TRUE; }
as                        { printf("T_AS\n"); return T_AS; }
assert                    { printf("T_ASSERT\n"); return T_ASSERT; }
async                     { printf("T_ASYNC\n"); return T_ASYNC; }
await                     { printf("T_AWAIT\n"); return T_AWAIT; }
break                     { printf("T_BREAK\n"); return T_BREAK; }
class                     { printf("T_CLASS\n"); return T_CLASS; }
continue                  { printf("T_CONTINUE\n"); return T_CONTINUE; }
def                       { printf("T_DEF\n"); return T_DEF; }
del                       { printf("T_DEL\n"); return T_DEL; }
elif                      { printf("T_ELIF\n"); return T_ELIF; }
else                      { printf("T_ELSE\n"); return T_ELSE; }
except                    { printf("T_EXCEPT\n"); return T_EXCEPT; }
finally                   { printf("T_FINALLY\n"); return T_FINALLY; }
for                       { printf("T_FOR\n"); return T_FOR; }
from                      { printf("T_FROM\n"); return T_FROM; }
global                    { printf("T_GLOBAL\n"); return T_GLOBAL; }
if                        { printf("T_IF\n"); return T_IF; }
import                    { printf("T_IMPORT\n"); return T_IMPORT; }
in                        { printf("T_IN\n"); return T_IN; }
is                        { printf("T_IS\n"); return T_IS; }
lambda                    { printf("T_LAMBDA\n"); return T_LAMBDA; }
nonlocal                  { printf("T_NONLOCAL\n"); return T_NONLOCAL; }
pass                      { printf("T_PASS\n"); return T_PASS; }
raise                     { printf("T_RAISE\n"); return T_RAISE; }
return                    { printf("T_RETURN\n"); return T_RETURN; }
try                       { printf("T_TRY\n"); return T_TRY; }
while                     { printf("T_WHILE\n"); return T_WHILE; }
with                      { printf("T_WITH\n"); return T_WITH; }
yield                     { printf("T_YIELD\n"); return T_YIELD; }


[a-zA-Z_][a-zA-Z0-9_]*    { printf("T_IDENTIFIER: %s\n", yytext); return T_IDENTIFIER; }

[ \t\n]                   ; /* Ignora espaços, tabs e novas linhas */

#[^\n]*                   ; /* Ignora comentários */

.                         ;   // IGNORA OUTROS CARACTERES POR ENQUANTO, REMOVAM ESSA LINHA DEPOIS QUE OS DEMAIS TOKENS ESTIVEREM PRONTOS



%%

int main() {
    while (yylex() != 0);  // Continua chamando yylex() até retornar 0 (fim da entrada)
    return 0;
}