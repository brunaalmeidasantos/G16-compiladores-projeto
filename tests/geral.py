# ======================================================================
# Arquivo de Teste Abrangente para o Compilador
#
# Este arquivo testa diversas funcionalidades da linguagem, incluindo:
# - Variáveis e aritmética
# - Estruturas de controle (if/else, while, for)
# - Funções e recursão
# - Impressão de diferentes tipos de dados
# ======================================================================

print("--- Iniciando testes do compilador ---")

# --- Teste de Variáveis e Aritmética ---
print("--- Teste 1: Variaveis e Aritmetica ---")
a = 10
b = 30.5
soma = a + b
sub = b - a
mult = a * 5
div = b / 2.0

print(soma)                 # Esperado: 40.5
print(sub)                  # Esperado: 20.5
print(mult)                 # Esperado: 50
print(div)                  # Esperado: 15.25

# --- Teste de Controle de Fluxo (if/else) ---
print("--- Teste 2: Controle de Fluxo (if/else) ---")
valor = 100
if valor > 50:
    print("Valor e maior que 50") # Esperado: Esta linha
else:
    print("Valor nao e maior que 50")

if soma == 40.5:
    print("A soma esta correta") # Esperado: Esta linha
else:
    print("A soma esta incorreta")

# --- Teste de Laço 'while' ---
print("--- Teste 3: Laco While ---")
contador_while = 0
resultado_while = 0
while contador_while < 5:
    resultado_while = resultado_while + contador_while
    contador_while = contador_while + 1

print("Resultado do while (0+1+2+3+4):")
print(resultado_while)      # Esperado: 10

# --- Teste de Laço 'for' ---
print("--- Teste 4: Laco For ---")
resultado_for = 0
for i in range(11):  # Soma de 0 a 10
    resultado_for = resultado_for + i

print("Resultado do for (soma de 0 a 10):")
print(resultado_for)        # Esperado: 55

# --- Teste de Funções ---
print("--- Teste 5: Funcoes ---")

def calcular_potencia(base, expoente):
    res = 1
    i = 0
    while i < expoente:
        res = res * base
        i = i + 1
    return res

pot = calcular_potencia(2, 8)
print("Resultado da funcao potencia (2^8):")
print(pot)                  # Esperado: 256


print("--- Fim dos testes ---")