# While com função no corpo
contador = 3
while contador > 0:
    contador = contador - 1

x = 10
if x == 10:
    resultado = 100

print(resultado)

def somar(a, b): # Função com parâmetros e chamada
    return a + b

print(somar(10, 20))

def dobro(n): # Função que chama outra função
    return n * 2

def processar(x):
    return dobro(x) + 1

def contar_ate(n):# Laços e condicionais dentro de função
    for i in range(n):
        resultado = n + 1
    return resultado
