# **Histórias de Usuário – Compylador**


<p align = "justify">Este documento apresenta o levantamento de histórias de usuário para o projeto Compylador, do grupo 16. O objetivo é compreender as necessidades e expectativas de diferentes perfis de usuários da linguagem Python, de forma a guiar as decisões de projeto e implementação do compilador.</p>

<p align = "justify">As histórias de usuário ajudam a entender as necessidades e expectativas dos possíveis usuários desse compilador. Neste documento, cada história apresenta um cenário, uma motivação e uma expectativa.</p>



## **Histórias de Usuário**

### **Usuário 1 – Estudante de Programação**

**Nome:** Ana, 19 anos. Aluna de Ciência da Computação, está aprendendo algoritmos básicos em Python.

**História:**

> *Como estudante iniciante,*
> *quero escrever programas simples em Python (com variáveis, estruturas condicionais e laços),*
> *para entender os fundamentos da lógica de programação.*

**Critérios de Aceitação:**

* O compilador deve aceitar variáveis simples, estruturas `if/else`, `for`, `while` e expressões aritméticas.
* O código resultante em C deve manter a lógica original.

<br>

### **Usuário 2 – Professor de Algoritmos**

**Nome:** Victor, 40 anos. Professor utiliza Python como linguagem introdutória em suas aulas.

**História:**

> *Como professor de algoritmos,*
> *quero converter exemplos didáticos de Python para C,*
> *para demonstrar como a mesma lógica se aplica em diferentes linguagens.*

**Critérios de Aceitação:**

* O compilador deve gerar código C legível e equivalente ao Python.
* O mapeamento das estruturas deve ser claro (ex: `for x in range(n)` → `for (int x = 0; x < n; x++)`).

<br>

### **Usuário 3 – Desenvolvedor de Scripts**

**Nome:** Matheus, 27 anos. Usa Python para scripts utilitários e automação simples.

**História:**

> *Como desenvolvedor de scripts simples,*
> *quero que meu código Python seja traduzido para C,*
> *para ganhar desempenho em tarefas repetitivas.*

**Critérios de Aceitação:**

* O compilador deve lidar com funções, chamadas e escopos básicos.
* Tipagem e conversão devem ser feitas automaticamente com base no uso.



<br>

<p align = "justify">As histórias de usuário levantadas refletem os principais casos de uso da linguagem Python no contexto de aprendizagem e desenvolvimento leve. Elas norteiam o escopo do compilador, garantindo que os recursos implementados atendam às expectativas reais e educativas dos usuários da linguagem.</p>
