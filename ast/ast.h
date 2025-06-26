#ifndef AST_H
#define AST_H

typedef enum {
    TIPO_INT,
    TIPO_STRING,
    TIPO_BOOL,
    TIPO_NONE,
    TIPO_ERRO,
    TIPO_FUNCAO,
    TIPO_FLOAT
} Tipo;

typedef enum {
    // Operadores Aritméticos
    OP_SOMA, OP_SUB, OP_MUL, OP_DIV, OP_MENOS_UNARIO,
    // Operadores de Comparação
    OP_EQ, OP_NE, OP_LT, OP_LE, OP_GT, OP_GE,
    // Operadores Lógicos
    OP_AND, OP_OR, OP_NOT,
    // Tipos de Nós (Statements e Estruturas)
    NODO_ATRIBUICAO,
    NODO_IF,
    NODO_WHILE,
    NODO_FOR,
    NODO_FUNC_DEF,
    NODO_CHAMADA_FUNC,
    NODO_RETURN,
    NODO_PRINT,
    NODO_BLOCO,
    NODO_LISTA_ARGS,
    // Tipos de Nós (Folhas e Identificadores)
    NODO_ID,
    NODO_NUM,
    NODO_STRING,
    NODO_BOOL,
    NODO_NONE,
    NODO_FLOAT,
    // Controle de Fluxo
    OP_BREAK,
    OP_CONTINUE
} Operador;

typedef struct noAST {
    Operador op;         // O tipo do nó ou do operador
    char nome[100];      // Usado para IDs
    int valor_int;       // Usado para números e booleanos
    float valor_float;   // Adicionado para números float
    char* valor_string;  // Usado para strings
    Tipo tipo_expressao; // Tipo inferido da expressão
    struct noAST *esq;   // Filho esquerdo (ou próximo comando em um bloco)
    struct noAST *dir;   // Filho direito (ou corpo de um if/while)
    struct noAST *ter;   // Terceiro filho (usado para else no if)
} NoAST;

// Nós de Operação e Expressão
NoAST *criarNoOp(Operador op, NoAST *esq, NoAST *dir);
NoAST *criarNoAtribuicao(char *nome, NoAST *valor);

// Nós Folha
NoAST *criarNoNum(int val);
NoAST *criarNoFloat(float val);
NoAST *criarNoId(char *nome);
NoAST *criarNoString(char *valor);
NoAST *criarNoBool(int valor);
NoAST *criarNoNone();

// Nós de Estrutura e Bloco
NoAST *criarNoBloco(NoAST* stmts, NoAST* nova_stmt);
NoAST *criarNoListaArgs(NoAST* lista, NoAST* novo_arg);

// Nós de Statement e Controle de Fluxo
NoAST *criarNoIf(NoAST *condicao, NoAST *corpo_if, NoAST *corpo_else);
NoAST *criarNoWhile(NoAST *condicao, NoAST *corpo);
NoAST *criarNoFor(char *var, NoAST* iteravel, NoAST* corpo);
NoAST *criarNoPrint(NoAST* expressao);
NoAST *criarNoFlow(Operador op_fluxo); // Para break/continue
NoAST *criarNoReturn(NoAST* valor_retorno);

// Nós de Função
NoAST *criarNoFuncao(char *nome, NoAST *parametros, NoAST *corpo);
NoAST *criarNoChamadaFunc(NoAST *argumentos);

void imprimirAST(NoAST *no);
const char* tipo_para_string(Tipo tipo);
Tipo tipo_from_string(const char* s);
Operador op_from_string(const char* s);

typedef struct {
    char* nome;
    Tipo tipo;
    int is_funcao; // 0 para variável, 1 para função
} Simbolo;

Simbolo* criarSimbolo(const char* nome, Tipo tipo, int is_funcao);

#endif