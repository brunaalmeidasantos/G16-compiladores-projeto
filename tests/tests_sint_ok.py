x = 10
if x:
    pass

texto = "Sou uma string"
print(texto)

def soma():
    return 5

resultado = soma()
print(resultado)

while x > 0:
    x = x - 1

for i in range(5):
    print(i)

# Atribuição múltipla
a, b = 1, 2
print(a)
print(b)

soma = 3 + 4 * 2 - (1 + 1)
print(soma)

# Uso de booleanos e operadores lógicos
ativo = True
if ativo and not False:
    print("Ativo")

def multiplicar(a, b):
    return a * b

print(multiplicar(2, 3))
