# Testes extras com estruturas válidas mais elaboradas

# Função com condicional interna
def mostrar():
    if True:
        return 1
    return 2

resultado = mostrar()
print(resultado)

# Função com parâmetros e chamada
def somar(a, b):
    return a + b

print(somar(10, 20))

# Função que chama outra função
def dobro(n):
    return n * 2

def processar(x):
    return dobro(x) + 1

print(processar(5))

# Laços e condicionais dentro de função
def contar_ate(n):
    total = 0
    for i in range(n):
        total = total + 1
    return total

print(contar_ate(4))

# While com função no corpo
contador = 3
while contador > 0:
    print(mostrar())
    contador = contador - 1
