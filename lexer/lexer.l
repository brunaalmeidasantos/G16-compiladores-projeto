%{
#include <stdio.h>
#include <stdlib.h>

int num_linha = 1;

#define PRINT_TOKEN(tok) printf("[linha %d] %s\n", num_linha, tok)
#define PRINT_TOKEN_TEXT(tok) printf("[linha %d] %s: %s\n", num_linha, tok, yytext)

enum t_tokens {
    T_STRING = 256,
    T_AND,
    T_OR,
    T_NOT,
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
    T_IDENTIFIER,
    T_LPAREN,
    T_RPAREN,
    T_LBRACKET,
    T_RBRACKET,
    T_LBRACE,
    T_RBRACE,
    T_COMMA,
    T_COLON,
    T_SEMICOLON,
    T_INDENT,
    T_NEWLINE,
    T_NUMBER,
    T_COMMENT,
    T_BLOCK_COMMENT,
    T_STAR,
    T_PLUS,
    T_OPTIONAL,
    T_BRACE_RANGE,
    T_EQ,
    T_NE,
    T_LT,
    T_LE,
    T_GT,
    T_GE
};

extern int yylineno;
extern char *yytext;
%}

%option noyywrap
%option yylineno

%%

DIGIT      [0-9]+
SPACE      [ \t\n]*

%% 

\"\"\"([^\"\\]|\\.|(\n))*\"\"\"    { PRINT_TOKEN_TEXT("T_STRING"); return T_STRING; }
\'\'\'([^\'\\]|\\.|(\n))*\'\'\'    { PRINT_TOKEN_TEXT("T_STRING"); return T_STRING; }
\"([^\"\\\n]|\\.)*\"               { PRINT_TOKEN_TEXT("T_STRING"); return T_STRING; }
\'([^\'\\\n]|\\.)*\'               { PRINT_TOKEN_TEXT("T_STRING"); return T_STRING; }
"("                       { PRINT_TOKEN("T_LPAREN"); return T_LPAREN; }
")"                       { PRINT_TOKEN("T_RPAREN"); return T_RPAREN; }
"["                       { PRINT_TOKEN("T_LBRACKET"); return T_LBRACKET; }
"]"                       { PRINT_TOKEN("T_RBRACKET"); return T_RBRACKET; }
"{"                       { PRINT_TOKEN("T_LBRACE"); return T_LBRACE; }
"}"                       { PRINT_TOKEN("T_RBRACE"); return T_RBRACE; }
","                       { PRINT_TOKEN("T_COMMA"); return T_COMMA; }
":"                       { PRINT_TOKEN("T_COLON"); return T_COLON; }
";"                       { PRINT_TOKEN("T_SEMICOLON"); return T_SEMICOLON; }
^[ \t]+                   { PRINT_TOKEN("T_INDENT"); return T_INDENT; }
[ \t]+                    ;
\n+                       { num_linha += yyleng; PRINT_TOKEN("T_NEWLINE"); return T_NEWLINE; }
and                       { PRINT_TOKEN("T_AND"); return T_AND; }
or                        { PRINT_TOKEN("T_OR"); return T_OR; }
not                       { PRINT_TOKEN("T_NOT"); return T_NOT; }
False                     { PRINT_TOKEN("T_FALSE"); return T_FALSE; }
None                      { PRINT_TOKEN("T_NONE"); return T_NONE; }
True                      { PRINT_TOKEN("T_TRUE"); return T_TRUE; }
as                        { PRINT_TOKEN("T_AS"); return T_AS; }
assert                    { PRINT_TOKEN("T_ASSERT"); return T_ASSERT; }
async                     { PRINT_TOKEN("T_ASYNC"); return T_ASYNC; }
await                     { PRINT_TOKEN("T_AWAIT"); return T_AWAIT; }
break                     { PRINT_TOKEN("T_BREAK"); return T_BREAK; }
class                     { PRINT_TOKEN("T_CLASS"); return T_CLASS; }
continue                  { PRINT_TOKEN("T_CONTINUE"); return T_CONTINUE; }
def                       { PRINT_TOKEN("T_DEF"); return T_DEF; }
del                       { PRINT_TOKEN("T_DEL"); return T_DEL; }
elif                      { PRINT_TOKEN("T_ELIF"); return T_ELIF; }
else                      { PRINT_TOKEN("T_ELSE"); return T_ELSE; }
except                    { PRINT_TOKEN("T_EXCEPT"); return T_EXCEPT; }
finally                   { PRINT_TOKEN("T_FINALLY"); return T_FINALLY; }
for                       { PRINT_TOKEN("T_FOR"); return T_FOR; }
from                      { PRINT_TOKEN("T_FROM"); return T_FROM; }
global                    { PRINT_TOKEN("T_GLOBAL"); return T_GLOBAL; }
if                        { PRINT_TOKEN("T_IF"); return T_IF; }
import                    { PRINT_TOKEN("T_IMPORT"); return T_IMPORT; }
in                        { PRINT_TOKEN("T_IN"); return T_IN; }
is                        { PRINT_TOKEN("T_IS"); return T_IS; }
lambda                    { PRINT_TOKEN("T_LAMBDA"); return T_LAMBDA; }
nonlocal                  { PRINT_TOKEN("T_NONLOCAL"); return T_NONLOCAL; }
pass                      { PRINT_TOKEN("T_PASS"); return T_PASS; }
raise                     { PRINT_TOKEN("T_RAISE"); return T_RAISE; }
return                    { PRINT_TOKEN("T_RETURN"); return T_RETURN; }
try                       { PRINT_TOKEN("T_TRY"); return T_TRY; }
while                     { PRINT_TOKEN("T_WHILE"); return T_WHILE; }
with                      { PRINT_TOKEN("T_WITH"); return T_WITH; }
yield                     { PRINT_TOKEN("T_YIELD"); return T_YIELD; }
[0-9]+(\.[0-9]+)?         { PRINT_TOKEN_TEXT("T_NUMBER: %s", yytext); return T_NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*    { PRINT_TOKEN_TEXT("T_IDENTIFIER: %s", yytext); return T_IDENTIFIER; }
\/\/[^\n]*                { PRINT_TOKEN("T_COMMENT: %s", yytext); return T_COMMENT; }
\/\*([^*]|\*+[^*/])*\*+\/ { PRINT_TOKEN("T_BLOCK_COMMENT: %s", yytext); return T_BLOCK_COMMENT; }
\*                        { PRINT_TOKEN("T_STAR"); return T_STAR; }
\+                        { PRINT_TOKEN("T_PLUS"); return T_PLUS; }
\?                        { PRINT_TOKEN("T_OPTIONAL"); return T_OPTIONAL; }
\{[0-9]+\}                { PRINT_TOKEN("T_BRACE_RANGE: %s", yytext); return T_BRACE_RANGE; }
\{[0-9]+,\}               { PRINT_TOKEN("T_BRACE_RANGE: %s", yytext); return T_BRACE_RANGE; }
\{[0-9]+,[0-9]+\}         { PRINT_TOKEN("T_BRACE_RANGE: %s", yytext); return T_BRACE_RANGE; }
==                        { PRINT_TOKEN("T_EQ"); return T_EQ; }
!=                        { PRINT_TOKEN("T_NE"); return T_NE; }
<=                        { PRINT_TOKEN("T_LE"); return T_LE; }
>=                        { PRINT_TOKEN("T_GE"); return T_GE; }
<                         { PRINT_TOKEN("T_LT"); return T_LT; }
>                         { PRINT_TOKEN("T_GT"); return T_GT; }
#[^\n]*                   ;
.                         ;

%%

int main() {
    while (yylex() != 0);
    return 0;
}