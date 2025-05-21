%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum t_tokens {
    T_STRING = 256,
    T_AND, T_OR, T_NOT,
    T_FALSE, T_NONE, T_TRUE,
    T_AS, T_ASSERT, T_ASYNC, T_AWAIT,
    T_BREAK, T_CLASS, T_CONTINUE, T_DEF, T_DEL,
    T_ELIF, T_ELSE, T_EXCEPT, T_FINALLY, T_FOR, T_FROM, T_GLOBAL,
    T_IF, T_IMPORT, T_IN, T_IS, T_LAMBDA, T_NONLOCAL,
    T_PASS, T_RAISE, T_RETURN, T_TRY, T_WHILE, T_WITH, T_YIELD,
    T_IDENTIFIER,
    T_LPAREN, T_RPAREN, T_LBRACKET, T_RBRACKET, T_LBRACE, T_RBRACE,
    T_COMMA, T_COLON, T_SEMICOLON,
    T_INDENT, T_NEWLINE,
    T_NUMBER,
    T_EQUAL
};
%}

%option noyywrap

%%

"="                        { printf("Operador '='\n"); return T_EQUAL; }

"("                        { printf("T_LPAREN\n"); return T_LPAREN; }
")"                        { printf("T_RPAREN\n"); return T_RPAREN; }
"["                        { printf("T_LBRACKET\n"); return T_LBRACKET; }
"]"                        { printf("T_RBRACKET\n"); return T_RBRACKET; }
"{"                        { printf("T_LBRACE\n"); return T_LBRACE; }
"}"                        { printf("T_RBRACE\n"); return T_RBRACE; }
","                        { printf("T_COMMA\n"); return T_COMMA; }
":"                        { printf("T_COLON\n"); return T_COLON; }
";"                        { printf("T_SEMICOLON\n"); return T_SEMICOLON; }

\"([^\"\\]|\\.)*\"          { printf("T_STRING: %s\n", yytext); return T_STRING; }
\'([^\'\\]|\\.)*\'          { printf("T_STRING: %s\n", yytext); return T_STRING; }

and                        { printf("T_AND\n"); return T_AND; }
or                         { printf("T_OR\n"); return T_OR; }
not                        { printf("T_NOT\n"); return T_NOT; }
False                      { printf("T_FALSE\n"); return T_FALSE; }
None                       { printf("T_NONE\n"); return T_NONE; }
True                       { printf("T_TRUE\n"); return T_TRUE; }
as                         { printf("T_AS\n"); return T_AS; }
assert                     { printf("T_ASSERT\n"); return T_ASSERT; }
async                      { printf("T_ASYNC\n"); return T_ASYNC; }
await                      { printf("T_AWAIT\n"); return T_AWAIT; }
break                      { printf("T_BREAK\n"); return T_BREAK; }
class                      { printf("T_CLASS\n"); return T_CLASS; }
continue                   { printf("T_CONTINUE\n"); return T_CONTINUE; }
def                        { printf("T_DEF\n"); return T_DEF; }
del                        { printf("T_DEL\n"); return T_DEL; }
elif                       { printf("T_ELIF\n"); return T_ELIF; }
else                       { printf("T_ELSE\n"); return T_ELSE; }
except                     { printf("T_EXCEPT\n"); return T_EXCEPT; }
finally                    { printf("T_FINALLY\n"); return T_FINALLY; }
for                        { printf("T_FOR\n"); return T_FOR; }
from                       { printf("T_FROM\n"); return T_FROM; }
global                     { printf("T_GLOBAL\n"); return T_GLOBAL; }
if                         { printf("T_IF\n"); return T_IF; }
import                     { printf("T_IMPORT\n"); return T_IMPORT; }
in                         { printf("T_IN\n"); return T_IN; }
is                         { printf("T_IS\n"); return T_IS; }
lambda                     { printf("T_LAMBDA\n"); return T_LAMBDA; }
nonlocal                   { printf("T_NONLOCAL\n"); return T_NONLOCAL; }
pass                       { printf("T_PASS\n"); return T_PASS; }
raise                      { printf("T_RAISE\n"); return T_RAISE; }
return                     { printf("T_RETURN\n"); return T_RETURN; }
try                        { printf("T_TRY\n"); return T_TRY; }
while                      { printf("T_WHILE\n"); return T_WHILE; }
with                       { printf("T_WITH\n"); return T_WITH; }
yield                      { printf("T_YIELD\n"); return T_YIELD; }

[0-9]+(\.[0-9]+)?          { printf("T_NUMBER: %s\n", yytext); return T_NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*     { printf("T_IDENTIFIER: %s\n", yytext); return T_IDENTIFIER; }

#[^\n]*                    { /* ignora comentários */ }

^[ \t]+                    { printf("T_INDENT\n"); return T_INDENT; }
[ \t]+                     { /* ignora espaço normal */ }

\n+                        { printf("T_NEWLINE\n"); return T_NEWLINE; }

.                          { printf("Outro: %s\n", yytext); return *yytext; }

%%

