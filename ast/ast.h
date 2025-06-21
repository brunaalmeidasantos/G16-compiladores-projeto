#ifndef AST_H
#define AST_H

typedef enum { 
    TIPO_INT, 
    TIPO_FLOAT, 
    TIPO_STRING,
    TIPO_BOOL,
    TIPO_NONE,
    TIPO_ERRO 
} Tipo;

typedef struct noAST {
    char operador;
    int valor;
    char nome[32];
    Tipo tipo;
    struct noAST *esquerda;
    struct noAST *direita;
    
    // Adicionei campos extras para suportar mais construções
    union {
        struct {
            struct noAST* condicao;
            struct noAST* corpo;
            struct noAST* corpo_else;
        } if_stmt;
        
        struct {
            struct noAST* condicao;
            struct noAST* corpo;
        } loop;
        
        struct {
            char* nome_funcao;
            struct noAST* parametros;
            struct noAST* corpo;
        } funcao;
    };
} NoAST;

// Funções básicas (do professor)
NoAST *criarNoOp(char op, NoAST *esq, NoAST *dir);
NoAST *criarNoNum(int val);
NoAST *criarNoId(char *nome, Tipo tipo);
void imprimirAST(NoAST *no);
int tiposCompativeis(Tipo t1, Tipo t2);

// Novas funções para suportar Python→C
NoAST *criarNoString(char *valor);
NoAST *criarNoBool(int valor);
NoAST *criarNoNone();
NoAST *criarNoIf(NoAST *condicao, NoAST *corpo, NoAST *corpo_else);
NoAST *criarNoWhile(NoAST *condicao, NoAST *corpo);
NoAST *criarNoFor(char *var, NoAST *iteravel, NoAST *corpo);
NoAST *criarNoFuncao(char *nome, NoAST *parametros, NoAST *corpo);
NoAST *criarNoAtribuicao(char *nome, NoAST *valor);

#endif