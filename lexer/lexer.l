%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../ast/ast.h"
#include "../parser.tab.h"

int line_num = 1;

void print_token(const char* token_name, const char* value) {
    printf("%s: %s\n", token_name, value);
}

void print_simple_token(const char* token_name) {
    printf("%s\n", token_name);
}
%}

%option noyywrap nounput noinput

%%

"="                        { print_simple_token("T_EQUAL"); return T_EQUAL; }
"+="                       { print_simple_token("T_PLUS_EQUAL"); return T_PLUS_EQUAL; }
"-="                       { print_simple_token("T_MINUS_EQUAL"); return T_MINUS_EQUAL; }
"=="                       { print_simple_token("T_EQ"); return T_EQ; }
"!="                       { print_simple_token("T_NE"); return T_NE; }
"<"                        { print_simple_token("T_LT"); return T_LT; }
"<="                       { print_simple_token("T_LE"); return T_LE; }
">"                        { print_simple_token("T_GT"); return T_GT; }
">="                       { print_simple_token("T_GE"); return T_GE; }
"*"                        { print_simple_token("T_STAR"); return T_STAR; }
"-"                        { print_simple_token("T_MINUS"); return T_MINUS; }
"+"                        { print_simple_token("T_PLUS"); return T_PLUS; }
"?"                        { print_simple_token("T_OPTIONAL"); return T_OPTIONAL; }
"\\"                        { print_simple_token("T_LBAR"); return T_LBAR; }
"/"                        { print_simple_token("T_RBAR"); return T_RBAR; }
"%"                        { print_simple_token("T_PORCENT"); return T_PORCENT; }

"("                        { print_simple_token("T_LPAREN"); return T_LPAREN; }
")"                        { print_simple_token("T_RPAREN"); return T_RPAREN; }
"["                        { print_simple_token("T_LBRACKET"); return T_LBRACKET; }
"]"                        { print_simple_token("T_RBRACKET"); return T_RBRACKET; }
"{"                        { print_simple_token("T_LBRACE"); return T_LBRACE; }
"}"                        { print_simple_token("T_RBRACE"); return T_RBRACE; }
","                        { print_simple_token("T_COMMA"); return T_COMMA; }
":"                        { print_simple_token("T_COLON"); return T_COLON; }
";"                        { print_simple_token("T_SEMICOLON"); return T_SEMICOLON; }
\{[0-9]+\}                 { print_simple_token("T_BRACE_RANGE"); return T_BRACE_RANGE; }
\{[0-9]+,\}                { print_simple_token("T_BRACE_RANGE"); return T_BRACE_RANGE; }
\{[0-9]+,[0-9]+\}          { print_simple_token("T_BRACE_RANGE"); return T_BRACE_RANGE; }

\'([^\\\n']|\\.)*\' {
    yylval.strval = strdup(yytext);
    print_token("T_STRING", yytext);
    return T_STRING;
}

\"([^\\\n"]|\\.)*\" {
    yylval.strval = strdup(yytext);
    print_token("T_STRING", yytext);
    return T_STRING;
}

"\'\'\'"([^\\]|\\.|\\\n)*?"\'\'\'" {
    yylval.strval = strdup(yytext);
    print_token("T_STRING", yytext);
    return T_STRING;
}

"\"\"\""([^\\]|\\.|\\\n)*?"\"\"\"" {
    yylval.strval = strdup(yytext);
    print_token("T_STRING", yytext);
    return T_STRING;
}


"and"                      { print_simple_token("T_AND"); return T_AND; }
"or"                       { print_simple_token("T_OR"); return T_OR; }
"not"                      { print_simple_token("T_NOT"); return T_NOT; }
"False"                    { print_simple_token("T_FALSE"); return T_FALSE; }
"None"                     { print_simple_token("T_NONE"); return T_NONE; }
"True"                     { print_simple_token("T_TRUE"); return T_TRUE; }
"as"                       { print_simple_token("T_AS"); return T_AS; }
"assert"                   { print_simple_token("T_ASSERT"); return T_ASSERT; }
"async"                    { print_simple_token("T_ASYNC"); return T_ASYNC; }
"await"                    { print_simple_token("T_AWAIT"); return T_AWAIT; }
"break"                    { print_simple_token("T_BREAK"); return T_BREAK; }
"class"                    { print_simple_token("T_CLASS"); return T_CLASS; }
"continue"                 { print_simple_token("T_CONTINUE"); return T_CONTINUE; }
"def"                      { print_simple_token("T_DEF"); return T_DEF; }
"del"                      { print_simple_token("T_DEL"); return T_DEL; }
"elif"                     { print_simple_token("T_ELIF"); return T_ELIF; }
"else"                     { print_simple_token("T_ELSE"); return T_ELSE; }
"except"                   { print_simple_token("T_EXCEPT"); return T_EXCEPT; }
"finally"                  { print_simple_token("T_FINALLY"); return T_FINALLY; }
"for"                      { print_simple_token("T_FOR"); return T_FOR; }
"from"                     { print_simple_token("T_FROM"); return T_FROM; }
"global"                   { print_simple_token("T_GLOBAL"); return T_GLOBAL; }
"if"                       { print_simple_token("T_IF"); return T_IF; }
"import"                   { print_simple_token("T_IMPORT"); return T_IMPORT; }
"in"                       { print_simple_token("T_IN"); return T_IN; }
"is"                       { print_simple_token("T_IS"); return T_IS; }
"lambda"                   { print_simple_token("T_LAMBDA"); return T_LAMBDA; }
"nonlocal"                 { print_simple_token("T_NONLOCAL"); return T_NONLOCAL; }
"pass"                     { print_simple_token("T_PASS"); return T_PASS; }
"print"                    { print_simple_token("T_PRINT"); return T_PRINT; }
"raise"                    { print_simple_token("T_RAISE"); return T_RAISE; }
"range"                    { print_simple_token("T_RANGE"); return T_RANGE; }
"return"                   { print_simple_token("T_RETURN"); return T_RETURN; }
"try"                      { print_simple_token("T_TRY"); return T_TRY; }
"while"                    { print_simple_token("T_WHILE"); return T_WHILE; }
"with"                     { print_simple_token("T_WITH"); return T_WITH; }
"yield"                    { print_simple_token("T_YIELD"); return T_YIELD; }

[0-9]+(\.[0-9]+)?          { yylval.intval = atoi(yytext); 
                             print_token("T_NUMBER", yytext); 
                             return T_NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*     { yylval.strval = strdup(yytext); 
                             print_token("T_IDENTIFIER", yytext); 
                             return T_IDENTIFIER;
                             if (strcmp(yytext, "int") == 0 || strcmp(yytext, "float") == 0)
                                return TIPO;
                                else
                                return ID; }

#[^\n]*                    { /* ignora comentários */ }

^[ \t]+                    { print_simple_token("T_INDENT"); return T_INDENT; }
[ \t\r]+                     { /* ignora espaço normal */ }

\n+                         { line_num++; 
                             print_simple_token("T_NEWLINE"); 
                             return T_NEWLINE; }

.                          { printf("Token não reconhecido: %s\n", yytext); 
                             return *yytext; }

%%