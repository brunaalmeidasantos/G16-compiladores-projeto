# **Avaliação de Riscos Técnicos – Compylador**
<p align = "justify"></p>

<p align = "justify">Este documento tem como objetivo identificar, descrever e avaliar os principais riscos técnicos envolvidos no desenvolvimento do <b>Compylador</b> - compilador que traduz a linguagem Python para C. Foram considerados riscos relacionados à gramática, desempenho, escopo, manutenção e limitações da linguagem-fonte ou destino.</p>

<p align = "justify">Os objetivos da avaliação de riscos são:</p>

* Prevenir falhas durante o desenvolvimento;
* Mapear antecipadamente as áreas críticas do projeto;
* Sugerir estratégias de mitigação para riscos identificados;
* Garantir que o compilador entregue o que foi proposto dentro dos prazos estabelecidos.


## Identificação dos Riscos Técnicos

### **1. Gramática Ambígua e Complexidade da Sintaxe de Python**

**Descrição:** Python possui algumas construções sintáticas que podem ser ambíguas ou difíceis de traduzir para C, como:  
- **Indentação como bloco estrutural** (em C, blocos são delimitados por `{}`).  
- **Dynamic typing** (Python é dinamicamente tipado, enquanto C é estático).  
- **List comprehensions, generators e funções lambda** (podem exigir transformações complexas em C).  

**Impacto:**  
- Dificuldade em mapear estruturas de alto nível de Python para C;
- Código gerado pode ser ineficiente ou ilegível.

**Probabilidade:** Alta

**Severidade:** Média

**Mitigação:** Restringir o projeto a um subconjunto de Python, sem orientação a objetos, apenas loops, condicionais e funções simples.



### **2. Gerenciamento de Tipos Dinâmicos vs. Estáticos**  

**Descrição:** Python permite que variáveis mudem de tipo dinamicamente, enquanto C exige declaração explícita de tipos.  

**Impacto:**  
- Se o compilador não fizer inferência de tipos, o código C gerado pode ser incorreto;
- Pode exigir estruturas extras (usar `union` ou `void*` para simular tipagem dinâmica).

**Probabilidade:** Alta

**Severidade:** Média

**Mitigação:** Definir regras de inferência de tipos simples (ex.: assumir `int` e `float` para números, `char*` para strings). 



### **3. Dependências Externas e Biblioteca Padrão**  

**Descrição:** Python tem uma biblioteca padrão extensa (ex.: `print()`, `len()`), mas C não oferece equivalentes diretos.  

**Impacto:**  
- Funções como `print()` precisarão ser reimplementadas em C (ex.: usando `printf`);
- Algumas operações podem exigir bibliotecas extras (ex.: alocação dinâmica para listas).

**Probabilidade:** Alta

**Severidade:** Média

**Mitigação:** Implementar apenas as funções essenciais (ex.: `print` → `printf`, `input` → `scanf`).  
 


### **4. Limites de Tempo e Escopo do Projeto**  

**Descrição:** O projeto tem prazo limitado (semestre acadêmico), o que pode limitar a implementação de algumas funcionalidades.  

**Impacto:** Recursos avançados (orientação a objetos, exceções) podem ficar de fora.  

**Probabilidade:** Alta

**Severidade:** Média

**Mitigação:** Priorizar um **núcleo mínimo funcional** (variáveis, loops, condicionais, funções).


<br>

---

<p align = "justify">Este documento destaca os principais riscos técnicos do projeto e propõe soluções para mitigá-los. A abordagem recomendada é começar com um subconjunto gerenciável de Python, e evoluí-lo conforme o tempo e capacidade da equipe permitir.</p>
