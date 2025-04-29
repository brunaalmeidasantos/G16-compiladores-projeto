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

<br>

## Tokens de Operadores Condicionais


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

>**T_IDENTIFIER**
> Representa identificadores (nomes de variáveis, funções, classes etc).
> **Regra usada:** `[a-zA-Z_][a-zA-Z0-9_]*`
> Essa expressão aceita palavras que comecem por letra ou `_`, seguidas por letras, números ou `_`. Compatível com nomes válidos em Python.
> **Exemplos de código:**
> ```python
> nome = "João"        # T_IDENTIFIER para nome
> calcularMedia()      # T_IDENTIFIER para calcularMedia
> _variavelInterna     # T_IDENTIFIER para _variavelInterna
> ```