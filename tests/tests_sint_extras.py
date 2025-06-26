x = 10
resultado = 0

def somar(a, b): # Função com parâmetros e chamada
    return a + b

def dobro(n): # Função que chama outra função
    return n * 2

def processar(x):
    return dobro(x) + 1

print(processar(5))

def contar_ate(n):# Laços e condicionais dentro de função
    total = 0
    i = 1
    for i in range(n):
        total = total + 1
    return total

print(contar_ate(4))

# While com função no corpo
contador = 3
while contador > 0:
    contador = contador - 1
    pass

print("oioi string")
