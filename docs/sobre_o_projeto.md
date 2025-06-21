# Sobre o Projeto

Somos o grupo 16 do projeto para a disciplina Compiladores 1, e o nosso projeto se chama **Compylador**, uma ferramenta de tradução dos comandos de **Python** para **C**. Este documento tem como finalidade apresentar as principais informações sobre o nosso projeto.

O objetivo do projeto é criar um compilador de linha de comando que recebe um programa simples em Python como entrada, e gera como saída um programa equivalente em C, mantendo a lógica e a estrutura funcional. A escolha do grupo de desenvolver um compilador que traduz programas de Python para C baseou-se nos seguintes fatores:

- **Relevância na prática:** Gerar código C a partir de Python aproxima nosso projeto de cenários do mundo real, onde linguagens de alto nível são traduzidas para linguagens de mais baixo nível para ganhar desempenho, portabilidade e controle.

- **Viabilidade:** Ao escolher trabalhar com um conjunto controlado de Python (funções, loops, condicionais), o projeto permanece viável dentro do tempo disponível, sem a necessidade de implementar toda a complexidade da linguagem.

Abaixo seguem os pontos principais a serem considerados sobre as linguagens **Python** e **C**.

<br>

**C:**  
> A linguagem C, criada nos anos 1970 por Dennis Ritchie, é uma linguagem de programação de propósito geral, conhecida por sua eficiência e controle de baixo nível sobre o hardware. Ela funciona compilando o código diretamente para linguagem de máquina, o que proporciona alta performance. C é muito utilizada em sistemas operacionais, sistemas embarcados e aplicações que exigem desempenho máximo.

<br>

**Python:**  
> Python, desenvolvido por Guido van Rossum em 1991, é uma linguagem de programação de alto nível focada em legibilidade e simplicidade. Ela funciona de maneira interpretada, ou seja, o código é lido e executado linha por linha por um interpretador. Python é amplamente usado para desenvolvimento rápido de aplicações, automações, análise de dados e inteligência artificial, graças à sua vasta biblioteca e facilidade de uso.

<br>

**Semelhanças entre C e Python:**  
> - Ambas são linguagens de propósito geral e podem ser usadas para construir diversos tipos de programas.  
> - Possuem ampla documentação e comunidades grandes, oferecendo suporte e ferramentas de desenvolvimento.  

<br>

**Diferenças entre C e Python:**  
> - **Tipagem:**  
>   - C tem tipagem estática e explícita; o programador precisa declarar o tipo de cada variável.  
>   - Python tem tipagem dinâmica e implícita; o tipo é determinado automaticamente em tempo de execução.
> - **Sintaxe:**  
>   - C possui uma sintaxe mais rígida, com necessidade de delimitadores como ponto e vírgula (`;`) e uso obrigatório de chaves (`{}`) para blocos.  
>   - Python adota uma sintaxe limpa baseada em indentação, sem necessidade de chaves ou ponto e vírgula.
> - **Bibliotecas padrão e funcionalidades embutidas:**  
>   - C oferece uma biblioteca padrão mais enxuta, com funções básicas para manipulação de arquivos, memória e entrada/saída.  
>   - Python possui uma biblioteca padrão muito extensa, oferecendo suporte nativo para manipulação de arquivos, redes, expressões regulares, interfaces gráficas e muito mais, sem necessidade de pacotes externos.

<br>

**Implicações de traduzir Python para C:**  
> - **Gestão de memória:** Em C, o programador precisa gerenciar manualmente a alocação e liberação de memória (com `malloc` e `free`), enquanto em Python existe coleta de lixo automática.  
> - **Controle de tipos:** Python permite mudanças dinâmicas de tipo em variáveis, mas em C é necessário definir o tipo de cada variável desde o início e respeitá-lo estritamente.  
> - **Complexidade da sintaxe:** A simplicidade da sintaxe Python seria perdida, já que C exige a escrita de mais código para operações simples, incluindo tratamento de erros manual.  
> - **Bibliotecas e funções nativas:** Muitas funcionalidades nativas de Python (como manipulação de listas, strings e arquivos) precisariam ser reimplementadas ou adaptadas usando bibliotecas padrão de C ou código manual.

<br>

# Estruturas do Python que serão traduzidas para C

Vale ressaltar que, para cada estrutura que será traduzida, será aceito apenas um nível de indentação, conforme abaixo:

```py
# Aceito:
if x == 10:
    print("x é 10!")

# Não aceito:
if x == 10:
    if 10 > 9:
        print("x é 10 e 10 é maior que 9!")
```

## Declarações de Variáveis
### O que representa em Python
- Variáveis são criadas dinamicamente ao receberem valores
- Tipagem dinâmica (o tipo é inferido do valor atribuído)
- Não requer declaração explícita de tipo

```python
# Exemplo Python
x = 10           # Inteiro
y = 3.14         # Float
nome = "Alice"   # String
```
### Tradução para C

- Declaração explícita do tipo antes do nome

- Atribuição pode ser feita na declaração ou depois

- Escopo definido pelo local de declaração

```c
// Forma geral
tipo nome_variavel;
tipo nome_variavel = valor;

// Exemplos
int idade = 25;
float altura = 1.75;
char letra = 'A';
```

## Laços (for, while)
### O que representa em Python
Estruturas de controle para repetição de blocos de código:

```python
# FOR - Forma geral em Python
for i in range(início, fim, passo):
    # Corpo do laço
    pass

# WHILE - Forma geral em Python
while condição:
    # Corpo do laço
    pass
```

### Tradução para C
- Sintaxe similar mas com diferenças importantes
- Uso obrigatório de chaves `{}`
- Controle mais explícito de iterações

```c
// FOR - Forma geral
for (inicialização; condição; incremento) {
    // Corpo do laço
}

// WHILE - Forma geral
while (condição) {
    // Corpo do laço
}
```

## Funções
### O que representa em Python
Blocos reutilizáveis de código definidos com `def`, que podem receber parâmetros e retornar valores.

```python
// Forma geral
tipo_retorno nome_funcao(tipo_param1 param1, tipo_param2 param2) {
    // Corpo da função
    return valor;
}
```

### Tradução para C
- Declaração explícita de tipos de retorno e parâmetros
- Uso de `return` similar ao Python
- Protótipo de função necessário quando chamado antes da definição

```c
// Forma geral
tipo_retorno nome_funcao(tipo_param1 param1, tipo_param2 param2) {
    // Corpo da função
    return valor;
}
```

## Condicionais

### O que representa em Python
- Estruturas usadas para tomar decisões com base em condições
- Usa `if`, `elif` (equivalente a `else if`), e `else`
- Os blocos são definidos por indentação

```python
# Exemplo Python
idade = 18

if idade >= 18:
    print("Maior de idade")
elif idade > 12:
    print("Adolescente")
else:
    print("Criança")
```
### Tradução para C
- Usa if, else if e else
- Blocos definidos com { } ao invés de indentação
```C
// Exemplo C
int idade = 18;

if (idade >= 18) {
    printf("Maior de idade\n");
} else if (idade > 12) {
    printf("Adolescente\n");
} else {
    printf("Criança\n");
}

```

<br>

## Gramática

A gramática definida para a construção do **Compylador** pode ser visualizada em docs/gramatica.md.
