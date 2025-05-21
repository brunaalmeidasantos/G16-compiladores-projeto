#include <stdio.h>
#include "ast.h"

int main() {
    // Teste 1: Expressão aritmética simples (2 + 3 * 5)
    NoAST* num2 = criarNoNum(2);
    NoAST* num3 = criarNoNum(3);
    NoAST* num5 = criarNoNum(5);
    NoAST* multiplicacao = criarNoOp('*', num3, num5);
    NoAST* soma = criarNoOp('+', num2, multiplicacao);

    printf("Expressão 1 (2 + 3 * 5): ");
    imprimirAST(soma);
    printf("\n\n");

    // Teste 2: Atribuição e if
    NoAST* varX = criarNoId("x", TIPO_INT);
    NoAST* atribuicao = criarNoAtribuicao("x", num5);
    NoAST* condicao = criarNoOp('>', varX, num3);
    NoAST* corpoIf = criarNoAtribuicao("y", num2);
    NoAST* ifStmt = criarNoIf(condicao, corpoIf, NULL);

    printf("Expressão 2 (if x > 3: y = 2):\n");
    imprimirAST(ifStmt);
    printf("\n\n");

    // Teste 3: Função com while
    NoAST* num1 = criarNoNum(1); // <- adicionando o num1 aqui!
    NoAST* incremento = criarNoOp('+', criarNoId("contador", TIPO_INT), num1);
    NoAST* corpoWhile = criarNoAtribuicao("contador", incremento);
    NoAST* condWhile = criarNoOp('<', criarNoId("contador", TIPO_INT), num5);
    NoAST* whileStmt = criarNoWhile(condWhile, corpoWhile);

    NoAST* funcao = criarNoFuncao("teste", NULL, whileStmt);

    printf("Expressão 3 (função com while):\n");
    imprimirAST(funcao);
    printf("\n");

    return 0;
}
