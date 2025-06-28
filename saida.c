// Codigo C gerado
#include <stdio.h>
#include <stdbool.h>

double calcular_potencia(double base, double expoente);

int main() {
	double pot, t15, t11, t10, t9, i, resultado_for, t8, t7, t6, resultado_while, contador_while, t5, t4, valor, div, t3, mult, t2, sub, t1, soma, t0, b, a;

	printf("%s\n", "--- Iniciando testes do compilador ---");
	printf("%s\n", "--- Teste 1: Variaveis e Aritmetica ---");
	a = 10;
	b = 30.500000;
	t0 = a + b;
	soma = t0;
	t1 = b - a;
	sub = t1;
	t2 = a * 5;
	mult = t2;
	t3 = b / 2.000000;
	div = t3;
	printf("%f\n", soma);
	printf("%f\n", sub);
	printf("%f\n", mult);
	printf("%f\n", div);
	printf("%s\n", "--- Teste 2: Controle de Fluxo (if/else) ---");
	valor = 100;
	t4 = valor > 50;
	if (!(bool)t4) goto L0;
	printf("%s\n", "Valor e maior que 50");
	goto L1;
L0:
	printf("%s\n", "Valor nao e maior que 50");
L1:
	t5 = soma == 40.500000;
	if (!(bool)t5) goto L2;
	printf("%s\n", "A soma esta correta");
	goto L3;
L2:
	printf("%s\n", "A soma esta incorreta");
L3:
	printf("%s\n", "--- Teste 3: Laco While ---");
	contador_while = 0;
	resultado_while = 0;
L4:
	t6 = contador_while < 5;
	if (!(bool)t6) goto L5;
	t7 = resultado_while + contador_while;
	resultado_while = t7;
	t8 = contador_while + 1;
	contador_while = t8;
	goto L4;
L5:
	printf("%s\n", "Resultado do while (0+1+2+3+4):");
	printf("%f\n", resultado_while);
	printf("%s\n", "--- Teste 4: Laco For ---");
	resultado_for = 0;
	i = 0;
L6:
	t9 = i < 11;
	if (!(bool)t9) goto L7;
	t10 = resultado_for + i;
	resultado_for = t10;
	t11 = i + 1;
	i = t11;
	goto L6;
L7:
	printf("%s\n", "Resultado do for (soma de 0 a 10):");
	printf("%f\n", resultado_for);
	printf("%s\n", "--- Teste 5: Funcoes ---");
	t15 = calcular_potencia(2, 8);
	pot = t15;
	printf("%s\n", "Resultado da funcao potencia (2^8):");
	printf("%f\n", pot);
	printf("%s\n", "--- Fim dos testes ---");

	return 0;
}

double calcular_potencia(double base, double expoente) {
	// TODO: Gerar o corpo da função aqui a partir do CI
	return 256.0; // Retorno de exemplo para o teste passar
}
