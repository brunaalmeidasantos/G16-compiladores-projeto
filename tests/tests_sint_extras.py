x = 10
resultado = 0
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

print(processar(5))

def contar_ate(n):# Laços e condicionais dentro de função
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

print('''
    oioi string
    com múltiplas
    linhas
''')
