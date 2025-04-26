# Introdução

Nós somos o grupo 16 da matéria de Compiladores, e o nosso projeto se chama **Compylador**, uma ferramenta de tradução dos comandos de **Python** para **C**. Abaixo seguem os pontos principais a serem considerados sobre as duas linguagens.

<br>

> **C:**  
> A linguagem C, criada nos anos 1970 por Dennis Ritchie, é uma linguagem de programação de propósito geral, conhecida por sua eficiência e controle de baixo nível sobre o hardware. Ela funciona compilando o código diretamente para linguagem de máquina, o que proporciona alta performance. C é muito utilizada em sistemas operacionais, sistemas embarcados e aplicações que exigem desempenho máximo.

<br>

> **Python:**  
> Python, desenvolvido por Guido van Rossum em 1991, é uma linguagem de programação de alto nível focada em legibilidade e simplicidade. Ela funciona de maneira interpretada, ou seja, o código é lido e executado linha por linha por um interpretador. Python é amplamente usado para desenvolvimento rápido de aplicações, automações, análise de dados e inteligência artificial, graças à sua vasta biblioteca e facilidade de uso.

<br>

> **Semelhanças entre C e Python:**  
> - Ambas são linguagens de propósito geral e podem ser usadas para construir diversos tipos de programas.  
> - Possuem ampla documentação e comunidades grandes, oferecendo suporte e ferramentas de desenvolvimento.  

<br>

> **Diferenças entre C e Python:**  
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

> **Implicações de traduzir Python para C:**  
> - **Gestão de memória:** Em C, o programador precisa gerenciar manualmente a alocação e liberação de memória (com `malloc` e `free`), enquanto em Python existe coleta de lixo automática.  
> - **Controle de tipos:** Python permite mudanças dinâmicas de tipo em variáveis, mas em C é necessário definir o tipo de cada variável desde o início e respeitá-lo estritamente.  
> - **Complexidade da sintaxe:** A simplicidade da sintaxe Python seria perdida, já que C exige a escrita de mais código para operações simples, incluindo tratamento de erros manual.  
> - **Bibliotecas e funções nativas:** Muitas funcionalidades nativas de Python (como manipulação de listas, strings e arquivos) precisariam ser reimplementadas ou adaptadas usando bibliotecas padrão de C ou código manual.   

