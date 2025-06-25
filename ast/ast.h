#ifndef AST_H
#define AST_H

// Enum para os tipos de dados da linguagem
typedef enum {
    TIPO_INT,
    TIPO_STRING,
    TIPO_BOOL,
    TIPO_NONE,
    TIPO_ERRO,
    TIPO_FUNCAO // Adicionado para funções
} Tipo;

// Enum para os tipos de nós e operadores
typedef enum {
    OP_SOMA, OP_SUB, OP_MUL, OP_DIV,
    OP_EQ, OP_NE, OP_LT, OP_LE, OP_GT, OP_GE, // Comparação
    OP_AND, OP_OR, OP_NOT, // Lógicos
    OP_MENOS_UNARIO,
    // Tipos de nós que não são operadores
    NODO_ATRIBUICAO,
    NODO_IF,
    NODO_WHILE,
    NODO_ID,
    NODO_NUM,
    NODO_STRING,
    NODO_BOOL,
    NODO_NONE,
    NODO_BLOCO
} Operador;

typedef struct noAST {
    Operador op;         // O tipo do nó ou do operador
    char nome[100];      // Usado para IDs
    int valor_int;       // Usado para números e booleanos
    char* valor_string;  // Usado para strings
    Tipo tipo_expressao; // *** NOVO: Tipo inferido da expressão ***
    struct noAST *esq;   // Filho esquerdo (ou próximo comando em um bloco)
    struct noAST *dir;   // Filho direito (ou corpo de um if/while)
    struct noAST *ter;   // Terceiro filho (usado para else no if)
} NoAST;

// Funções para criar nós da AST
NoAST *criarNoOp(Operador op, NoAST *esq, NoAST *dir);
NoAST *criarNoNum(int val);
NoAST *criarNoId(char *nome);
NoAST *criarNoString(char *valor);
NoAST *criarNoBool(int valor);
NoAST *criarNoNone();
NoAST *criarNoIf(NoAST *condicao, NoAST *corpo_if, NoAST *corpo_else);
NoAST *criarNoWhile(NoAST *condicao, NoAST *corpo);
NoAST *criarNoAtribuicao(char *nome, NoAST *valor);
NoAST *criarNoBloco(NoAST* stmts, NoAST* nova_stmt);

// Funções Auxiliares
void imprimirAST(NoAST *no);
const char* tipo_para_string(Tipo tipo); // Converte enum para string para erros
Tipo tipo_from_string(const char* s);
Operador op_from_string(const char* s);

// Definição do Símbolo para a Tabela de Símbolos
// Colocando aqui para ser acessível por parser e semantico
typedef struct {
    char* nome;
    Tipo tipo;
    int is_funcao; // 0 para variável, 1 para função
    // Poderia adicionar número de parâmetros, etc.
} Simbolo;

Simbolo* criarSimbolo(const char* nome, Tipo tipo, int is_funcao);


#endif