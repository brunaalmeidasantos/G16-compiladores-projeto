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


<br>

## Tokens de Palavras-Chave


<br>

## Tokens de Quebra de Linha


<br>

## Tokens de String


<br>

## Tokens de Espaço e Delimitador


<br>

## Tokens de Números


<br>

## Tokens de Identificadores

