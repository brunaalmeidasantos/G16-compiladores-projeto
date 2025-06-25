# 🌳 AST - Árvore de Sintaxe Abstrata

Este módulo implementa uma **AST (Abstract Syntax Tree)** — um dos pilares da construção de compiladores e interpretadores. Ele serve para representar a estrutura lógica de um programa de forma hierárquica, permitindo a análise, transformação ou tradução de código-fonte.

## 📁 Estrutura

- `ast.h` – Declaração da estrutura da árvore e das funções de manipulação.
- `ast.c` – Implementação das funções que criam e imprimem a AST.

---

## 🧠 O que é uma AST?

A AST funciona como uma **árvore genealógica do seu código**: cada nó representa um elemento da linguagem — como números, variáveis, expressões, comandos de controle (`if`, `while`, etc).

> Em vez de lidar com linhas de código, o compilador usa a AST para entender "o que" está sendo feito, "como" está estruturado, e "qual o tipo" de cada coisa.

---

## 🔧 Funcionalidades

O sistema atual permite criar nós para:

### ✅ Elementos Básicos

- **Inteiros** (`criarNoNum`)
- **Strings** (`criarNoString`)
- **Booleanos** (`criarNoBool`)
- **None** (`criarNoNone`)
- **Variáveis** (`criarNoId`)
- **Operações Aritméticas** (`criarNoOp`)

### 🧠 Estruturas de Controle

- **If/Else** (`criarNoIf`)
- **While** (`criarNoWhile`)
- **For** (`criarNoFor`)

### 🧾 Outras Construções

- **Atribuição de valor** (`criarNoAtribuicao`)
- **Definição de função** (`criarNoFuncao`)

### 🖨️ Impressão da Árvore

- `imprimirAST`: Imprime a árvore em uma representação legível, próxima do código original.

---

## 🧱 Exemplo de Uso

```c
NoAST *x = criarNoNum(10);
NoAST *y = criarNoNum(20);
NoAST *soma = criarNoOp('+', x, y);
imprimirAST(soma); // (10 + 20)
