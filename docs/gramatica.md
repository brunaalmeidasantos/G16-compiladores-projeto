# Gramática do Compylador

Este documento apresenta os tokens da linguagem Python definidos no analisador léxico do projeto **Compylador** - Compilador Python para C.



## Tokens de Comentários

> **T_COMMENT:**  
> Representa comentários de linha única iniciados por `//`.  
> **Regra usada:** `\/\/[^\n]*`  
> Esta expressão regular identifica qualquer linha que comece com `//` e capture todo o conteúdo até o final da linha.  
> **Exemplo de código:**  
> ```c
> // Este é um comentário de linha
> ```

> **T_BLOCK_COMMENT:**  
> Representa comentários de bloco, iniciados por `/*` e terminados por `*/`.  
> **Regra usada:** `\/\*([^*]|\*+[^*/])*\*+\/`  
> Esta expressão regular captura corretamente comentários de múltiplas linhas que começam com `/*` e terminam com `*/`.  
> **Exemplo de código:**  
> ```c
> /* Este é um
>    comentário de bloco */
> ```

<br>

## Tokens de Operadores Quantitativos

> **T_STAR:**  
> Representa o símbolo `*`.  
> **Regra usada:** `\*`  
> Detecta o operador de multiplicação ou símbolo de repetição.  
> **Exemplo de código:**  
> ```c
> a * b;
> ```

> **T_PLUS:**  
> Representa o símbolo `+`.  
> **Regra usada:** `\+`  
> Detecta o operador de adição ou de repetição obrigatória (dependendo do contexto).  
> **Exemplo de código:**  
> ```c
> a + b;
> ```

> **T_OPTIONAL:**  
> Representa o símbolo `?`.  
> **Regra usada:** `\?`  
> Detecta o operador que indica opcionalidade de elementos.  
> **Exemplo de código:**  
> ```c
> valor? outro_valor : valor_padrao;
> ```

> **T_BRACE_RANGE:**  
> Representa expressões que usam chaves `{}` para definir repetições, como `{n}`, `{n,}`, ou `{n,m}`.  
> **Regras usadas:**  
> - `\{[0-9]+\}`  
> - `\{[0-9]+,\}`  
> - `\{[0-9]+,[0-9]+\}`  
> Essas expressões regulares detectam padrões de repetição específicos usados, por exemplo, em expressões regulares para definir quantidades mínimas e máximas.  
> **Exemplos de código:**  
> ```c
> {3}
> {2,}
> {1,5}
> ```

Esses tokens são reconhecidos utilizando expressões regulares no analisador léxico.  
Cada vez que um padrão é encontrado, um `printf` exibe o token identificado, ajudando na validação do processo de análise.


---

## Tokens de Operadores Condicionais

> **T_EQ:**  
> Representa o operador de igualdade `==`.  
> **Regra usada:** `==`  
> Detecta comparações onde se verifica se dois valores são iguais.  
> **Exemplo de código:**  
> ```py
> if a == b:
> ```

> **T_NE:**  
> Representa o operador de diferença `!=`.  
> **Regra usada:** `!=`  
> Detecta comparações onde se verifica se dois valores são diferentes.  
> **Exemplo de código:**  
> ```py
> if a != b:
> ```

> **T_LT:**  
> Representa o operador de menor que `<`.  
> **Regra usada:** `<`  
> Detecta comparações para verificar se um valor é menor que outro.  
> **Exemplo de código:**  
> ```py
> if a < b:
> ```

> **T_LE:**  
> Representa o operador de menor ou igual `<=`.  
> **Regra usada:** `<=`  
> Detecta comparações onde um valor pode ser menor ou igual a outro.  
> **Exemplo de código:**  
> ```py
> if a <= b:
> ```

> **T_GT:**  
> Representa o operador de maior que `>`.  
> **Regra usada:** `>`  
> Detecta comparações para verificar se um valor é maior que outro.  
> **Exemplo de código:**  
> ```py
> if a > b:
> ```

> **T_GE:**  
> Representa o operador de maior ou igual `>=`.  
> **Regra usada:** `>=`  
> Detecta comparações onde um valor pode ser maior ou igual a outro.  
> **Exemplo de código:**  
> ```py
> if a >= b:
> ```

> **T_IS:**  
> Representa o operador `is`.  
> **Regra usada:** `is`  
> Detecta comparações de identidade entre objetos.  
> **Exemplo de código:**  
> ```py
> if x is None:
> ```

> **T_IN:**  
> Representa o operador `in`.  
> **Regra usada:** `in`  
> Detecta se um elemento pertence a uma sequência ou coleção.  
> **Exemplo de código:**  
> ```py
> if item in lista:
> ```

> **T_NOT:**  
> Representa o operador `not`, usado também em expressões compostas (`not in`, `is not`).  
> **Regra usada:** `not`  
> Detecta a negação de uma condição ou participação em expressões compostas.  
> **Exemplo de código:**  
> ```py
> if not ativo:
> if x is not None:
> if item not in lista:
> ```


<br>

## Tokens de Operadores Lógicos
> **T_AND:**  
> Representa o operador lógico `and`.  
> **Regra usada:** `and`  
> Detecta o operador lógico `and`.  
> **Exemplo de código:**  
> ```py
> isNumber and isPositive
> ```

> **T_OR:**  
> Representa o operador lógico `or`.  
> **Regra usada:** `or`  
> Detecta o operador lógico `or`.  
> **Exemplo de código:**  
> ```py
> isNumber or isString
> ```

> **T_NOT:**  
> Representa o operador lógico `not`.  
> **Regra usada:** `not` 
> Detecta o operador lógico `not`.  
> **Exemplo de código:**  
> ```py
> not isNumber
> ``` 

<br>

## Tokens de Palavras-Chave

> **T_TRUE:**  
> Representa o valor booleano `True`.  
> **Regra usada:** `True`  
> Identifica o valor verdadeiro na linguagem Python.  
> **Exemplo de código:**  
> ```py
> ativo = True
> ``` 

> **T_FALSE:**  
> Representa o valor booleano `False`.  
> **Regra usada:** `False`  
> Identifica o valor falso na linguagem Python.  
> **Exemplo de código:**
> ```py
> x = False
> ``` 

> **T_NONE:**  
> Representa o valor nulo `None`.  
> **Regra usada:** `None`  
> Identifica a ausência de valor em Python.  
> **Exemplo de código:**
> ```py
> resultado = None
> ``` 

> **T_AS:**  
> Representa a palavra-chave `as`.  
> **Regra usada:** `as`  
> Usado em expressões de importação e gerenciamento de contexto.  
> **Exemplo de código:**  
> ```py
> import math as m
> ``` 

> **T_ASSERT:**    
> Representa a palavra-chave `assert`.    
> **Regra usada:** `assert`    
> Usado para verificar condições durante o desenvolvimento.  
> **Exemplo de código:** 
> ```py
> assert x > 0, "x deve ser positivo"
> ``` 

> **T_ASYNC:**  
> Representa a palavra-chave `async`.  
> **Regra usada:** `async`  
> Define funções assíncronas.  
> **Exemplo de código:**    
> ```py
> async def fetch_data():
> ```

> **T_AWAIT:**  
> Representa a palavra-chave `await`.  
> **Regra usada:** `await`  
> Usado para esperar por corrotinas.  
> **Exemplo de código:**  
> ```py
> result = await some_task()
> ```

> **T_BREAK:**  
> Representa a palavra-chave `break`.  
> **Regra usada:** `break`  
> Interrompe loops.  
> **Exemplo de código:**  
> ```py
> while True:
>    break
> ```

> **T_CLASS:**  
> Representa a palavra-chave `class`.  
> **Regra usada:** `class`  
> Define classes.  
> **Exemplo de código:**  
> ```py
> class MinhaClasse:
> ```

> **T_CONTINUE:**  
> Representa a palavra-chave `continue`.  
> **Regra usada:** `continue`  
> Pula para a próxima iteração do loop.  
> **Exemplo de código:**  
> ```py
> for i in range(10):
>    if i % 2:
>         continue
> ```

> **T_DEF:**  
> Representa a palavra-chave `def`.  
> **Regra usada:** `def`  
> Define funções.  
> **Exemplo de código:**  
> ```py
> def calcular():
> ```

> **T_DEL:**  
> Representa a palavra-chave `del`.  
> **Regra usada:** `del`  
> Remove referências a objetos.  
> **Exemplo de código:**  
> ```py
> del lista[0]
> ```

> **T_ELIF:**  
> Representa a palavra-chave `elif`.  
> **Regra usada:** `elif`  
> Condicional "else if".  
> **Exemplo de código:**  
> ```py
> if x > 0:
>     ...
> elif x < 0:
> ```

> **T_ELSE:**  
> Representa a palavra-chave `else`.  
> **Regra usada:** `else`  
> Cláusula final condicional.  
> **Exemplo de código:**  
> ```py
> if x > 0:
>     ...
> else:
> ```

> **T_EXCEPT:**  
> Representa a palavra-chave `except`.  
> **Regra usada:** `except`  
> Captura exceções.  
> **Exemplo de código:**  
> ```py
> try:
>     ...
> except ValueError:
> ```

> **T_FINALLY:**  
> Representa a palavra-chave `finally`.  
> **Regra usada:** `finally`  
> Executa código independentemente de exceções.  
> **Exemplo de código:**  
> ```py
> try:
>     ...
> finally:
>     cleanup()
> ```

> **T_FOR:**  
> Representa a palavra-chave `for`.  
> **Regra usada:** `for`  
> Inicia loops.  
> **Exemplo de código:**    
> ```py
> for item in lista:
> ```

> **T_FROM:**  
> Representa a palavra-chave `from`.  
> **Regra usada:** `from`  
> Usado em importações.  
> **Exemplo de código:**  
> ```py
> from math import sqrt
> ```

> **T_GLOBAL:**  
> Representa a palavra-chave `global`.  
> **Regra usada:** `global`  
> Declara variáveis globais.  
> **Exemplo de código:**  
> ```py
> global contador
> ```

> **T_IF:**  
> Representa a palavra-chave `if`.  
> **Regra usada:** `if`  
> Inicia condicionais.  
> **Exemplo de código:**  
> ```py
> if condicao:
> ```

> **T_IMPORT:**  
> Representa a palavra-chave `import`.  
> **Regra usada:** `import`  
> Importa módulos.  
> **Exemplo de código:**  
> ```py
> import os
> ```

> **T_IN:**  
> Representa a palavra-chave `in`.  
> **Regra usada:** `in`  
> Testa pertencimento.  
> **Exemplo de código:**  
> ```py
> if x in lista:
> ```

> **T_IS:**  
> Representa a palavra-chave `is`.  
> **Regra usada:** `is`  
> Compara identidade de objetos.  
> **Exemplo de código:**  
> ```py
> if x is None:
> ```

> **T_LAMBDA:**  
> Representa a palavra-chave `lambda`.  
> **Regra usada:** `lambda`  
> Cria funções anônimas.  
> **Exemplo de código:**  
> ```py
> f = lambda x: x*2
> ```

> **T_NONLOCAL:**  
> Representa a palavra-chave `nonlocal`.  
> **Regra usada:** `nonlocal`  
> Declara variáveis não-locais.  
> **Exemplo de código:**  
> ```py
> nonlocal x
> ```

> **T_PASS:**  
> Representa a palavra-chave `pass`.  
> **Regra usada:** `pass`  
> Operação nula.  
> **Exemplo de código:**  
> ```py
> def funcao_vazia():
>    pass
> ```

> **T_RAISE:**  
> Representa a palavra-chave `raise`.  
> **Regra usada:** `raise`  
> Levanta exceções.  
> **Exemplo de código:**  
> ```py
> raise ValueError("Erro")
> ```

> **T_RETURN:**  
> Representa a palavra-chave `return`.  
> **Regra usada:** `return`  
> Retorna valores de funções.  
> **Exemplo de código:**  
> ```py
> return resultado
> ```

> **T_TRY:**  
> Representa a palavra-chave `try`.  
> **Regra usada:** `try`  
> Inicia blocos de tratamento de exceção.  
> **Exemplo de código:**  
> ```py
> try:
>   operacao_risco()
> ```

> **T_WHILE:**  
> Representa a palavra-chave `while`.  
> **Regra usada:** `while`  
> Inicia loops condicionais.  
> **Exemplo de código:**  
> ```py
> while condicao:
> ```

> **T_WITH:**  
> Representa a palavra-chave `with`.  
> **Regra usada:** `with`  
> Gerenciamento de contexto.  
> **Exemplo de código:**  
> ```py
> with open('file.txt') as f:
> ```

> **T_YIELD:**  
> Representa a palavra-chave `yield`.  
> **Regra usada:** `yield`  
> Cria geradores.  
> **Exemplo de código:**  
> ```py
> yield valor
> ```


<br>

## Tokens de Quebra de Linha
> **T_NEWLINE:**  
> Representa quebras de linha (`\n`).  
> **Regra usada:** `\n+`  
> Detecta uma ou mais ocorrências de `\n`, essencial para delimitar instruções em Python.  
> **Exemplo de código:**  
> ```python
> x = 10  # T_NEWLINE gerado aqui
> y = 20
> ```

<br>

## Tokens de String
> **T_STRING:**  
> Representa strings iniciadas e terminadas por aspas duplas (`"`).  
> **Regra usada:** `\"([^\"\\]|\\.)*\"`  
> Esta expressão regular identifica qualquer string delimitada por `"`. A regra permite que a string possua aspas duplas em seu conteúdo, conforme regras para utilização da mesma nesse caso.  
> **Exemplo de código:**  
> ```py
> "Isso é uma string com aspas duplas."
> ```

> **T_STRING:**  
> Representa strings iniciadas e terminadas por aspas simples (`'`).  
> **Regra usada:** `'([^\'\\]|\\.)*\`  
> Esta expressão regular identifica qualquer string delimitada por `'`. A regra permite que a string possua aspas simples em seu conteúdo, conforme regras para utilização da mesma nesse caso.  
> **Exemplo de código:**  
> ```py
> 'Isso é uma string com aspas simples.'
> ```

<br>

## Tokens de Espaço e Delimitador
> **T_INDENT:**  
> Representa indentação no início de linha (espaços ou tabs).  
> **Regra usada:** `^[ \t]+`  
> Captura espaços/tabs apenas no início da linha.  
> **Exemplo de código:**  
> ```python
> if True:
>     print("Indentado")  # T_INDENT aqui
> ```

> **T_COMMA:**  
> Representa o delimitador `,`.  
> **Regra usada:** `,`  
> Usado para separar elementos em listas, tuplas ou parâmetros.  
> **Exemplo de código:**  
> ```python
> [1, 2, 3]  # T_COMMA identificado
> ```

> **T_COLON:**  
> Representa o símbolo `:`.  
> **Regra usada:** `:`  
> Define blocos de código (if/for/def) e dicionários.  
> **Exemplo de código:**  
> ```python
> def função():  # T_COLON aqui
> ```

> **T_SEMICOLON:**  
> Representa `;`.  
> **Regra usada:** `;`  
> Separa múltiplos comandos numa linha.
> **Exemplo de código:**  
> ```python
> x=1; y=2  # T_SEMICOLON
> ```

> **Espaços ignorados:**  
> **Regra usada:** `[ \t]+`  
> Espaços/tabs no meio da linha não geram tokens.  


<br>

## Tokens de Números

> **T_NUMBER:**
> Representa valores numéricos inteiros ou decimais.
> **Regra usada:** `[0-9]+(\.[0-9]+)?`
> Essa expressão identifica números inteiros como `42` ou decimais como `3.14`. O ponto e a parte decimal são opcionais, o que permite que inteiros sejam aceitos.
> **Exemplos de código:**
> ```python
> idade = 25       # T_NUMBER gerado para 25
> pi = 3.14        # T_NUMBER gerado para 3.14
> ```

<br>

## Tokens de Identificadores

> **T_IDENTIFIER**
> Representa identificadores (nomes de variáveis, funções, classes etc).
> **Regra usada:** `[a-zA-Z_][a-zA-Z0-9_]*`
> Essa expressão aceita palavras que comecem por letra ou `_`, seguidas por letras, números ou `_`. Compatível com nomes válidos em Python.
> **Exemplos de código:**
> ```python
> nome = "João"        # T_IDENTIFIER para nome
> calcularMedia()      # T_IDENTIFIER para calcularMedia
> _variavelInterna     # T_IDENTIFIER para _variavelInterna
> ```
