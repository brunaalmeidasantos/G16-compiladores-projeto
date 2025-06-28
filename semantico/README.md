# Analisador Semântico

## O que é?

<p align = "justify">O analisador semântico é a terceira etapa do processo de compilação. Após a análise léxica e sintática, o analisador semântico valida os significados das construções gramaticais, assegurando que estejam corretas de acordo com as regras da linguagem. No contexto do Compylador, o analisador semântico verifica, por exemplo:</p>

* Uso de variáveis não declaradas;
* Tipos incompatíveis em expressões e atribuições;
* Uso adequado de funções;
* Contexto correto de controle de fluxo (`return`, `break`, etc.).

<p align = "justify">O analisador semântico garante que o código Python de entrada possua sentido lógico e consistente, impedindo que códigos semanticamente inválidos avancem para as etapas de tradução e geração de código C. Ele é uma etapa essencial para garantir a correção do programa compilado.</p>

## Como funciona?

<p align = "justify">O [analisador semântico](./semantico.c) percorre a AST (Árvore Sintática Abstrata) e aplica validações semânticas sobre os nós da árvore. Suas principais funções são:</p>

1. Percorrer recursivamente os nós da AST;
2. Verificar a consistência semântica de declarações e expressões;
3. Emitir erros semânticos com informações de linha e tipo de erro;
4. Preencher ou consultar a tabela de símbolos, garantindo que identificadores estejam corretamente definidos e utilizados.

## Exemplo

Código fonte com erro semântico:

```py
x = 10
y = "texto"
z = x + y  # Erro: tipos incompatíveis (int + string)
```

A análise semântica reportaria:

```
Erro semântico na linha 3: Tipos incompatíveis na operação '+' (int e str)
```



## Explicando o código

O arquivo `semantico.c` implementa funções que percorrem a AST, utilizando a estrutura `Node` (definida em `arvore.h`) e a tabela de símbolos (definida em `hash.h`) para realizar validações semânticas.

### Cabeçalhos e variáveis globais

```c
#include "arvore.h"
#include "hash.h"
#include "tipos.h"
```

Esses arquivos definem:

* `arvore.h`: estrutura da AST;
* `hash.h`: tabela de símbolos usada para verificar declarações;
* `tipos.h`: funções para inferência de tipo e enumerações como `TYPE_INT`, `TYPE_STRING`, etc.

A variável `tabela_simbolos` é usada para acessar a tabela de símbolos durante a verificação.

### Função principal

```c
void verifica_no(Node *no);
```

Essa função percorre a árvore sintática chamando funções específicas para cada tipo de nó: atribuição, declaração, expressão, chamada de função, etc.

### Inferência de tipos

```c
Tipo verifica_tipo(Node *no);
```

Essa função determina o tipo semântico de um nó (por exemplo, `int`, `float`, `str`). Ela trata casos como:

* Literais (`10`, `"texto"`, `True`);
* Operações binárias (`+`, `-`, `*`);
* Expressões booleanas e relacionais;
* Identificadores, com base na tabela de símbolos.

### Verificações específicas

Algumas funções auxiliam a verificação de construtos específicos:

* `verifica_atribuicao()`: valida se o lado esquerdo está declarado e se o tipo do lado direito é compatível;
* `verifica_variavel()`: verifica se uma variável foi declarada antes do uso;
* `verifica_funcao()`: pode ser expandida para suportar verificação de funções e parâmetros;
* `verifica_expressao()`: percorre operações e subexpressões, chamando `verifica_tipo` para cada lado da operação;
* `verifica_argumentos()`: confere os tipos dos argumentos em chamadas de função, se necessário.

### Erros semânticos

Os erros são reportados com a linha do código-fonte:

```c
printf("Erro semântico na linha %d: %s\n", no->linha, mensagem);
```

O analisador semântico não interrompe a execução após o primeiro erro, permitindo detectar múltiplos problemas em uma única passada.
