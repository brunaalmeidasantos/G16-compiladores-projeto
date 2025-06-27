# G16 - Compilador Python para C

Repositório dedicado ao desenvolvimento do projeto Compylador do Grupo 16 para a disciplina Compiladores 1, ministrada pelo professor Sergio Freitas durante o 1º semestre de 2025, na Universidade de Brasília (UnB).

## Equipe
|Integrante|Matrícula|
|----------|---------|
|Ana Luiza Hoffmann Ferreira|202015901|
|Bruna Almeida Santos|170100626|
|Italo Bruno Avelino da Silva Melo|190133813|
|Matheus Barros do Nascimento|190126515|
|Matheus Moreira Lopes Perillo|190093421|
|Victor Augusto de Sousa Camara|221031238|

---
## O projeto

O projeto elaborado por nosso grupo consiste em um **compilador que traduz um subconjunto da linguagem Python para C**; O intitulamos **Compylador**. A proposta é permitir que programas escritos em Python, com uma sintaxe e estruturas definidas previamente, possam ser convertidos para código C equivalente, mantendo sua lógica e funcionalidade.

O compilador está sendo desenvolvido utilizando as ferramentas **Flex** e **Bison**, e segue as principais etapas de construção de um compilador:
- **Análise léxica**, responsável por identificar os *tokens* da linguagem;
- **Análise sintática**, que verifica a estrutura do código com base em uma gramática livre de contexto;
- **Análise semântica**, que valida o uso correto de variáveis, tipos e estruturas;
- **Geração de código**, que converte o programa Python para um código C funcional.

---
## Escopo e Limitações
É importante ressaltar que o presente compilador focará na tradução de um subconjunto específico da linguagem Python. Dentre as funcionalidades **não** contempladas neste projeto, destaca-se o tratamento de **orientação a objetos**. Construções como classes, objetos e herança não serão processadas pelo compilador.

Além disso, múltiplos níveis de indentação também não serão compilados. A adição dessa limitação se deu a partir da necessidade de reduzir o escopo do projeto para se adequar às entregas exigidas pela disciplina Compiladores 1, da Universidade de Brasília. Isso torna viável a entrega de um compilador básico funcional como trabalho final.

---
## Organização e Cronograma do Projeto

A equipe está utilizando as metodologias ágeis **Scrum** e **Kanban** para organizar e acompanhar o desenvolvimento do projeto. As atividades são gerenciadas por meio de um quadro Kanban, que permite o acompanhamento contínuo das tarefas a fazer, em andamento e concluídas a cada Sprint. O projeto está dividido em **5 sprints**, cada uma com duração média de **duas semanas**; As Sprints podem ser visualizadas na aba _Projects_ do repositório.

Além da entrega final, o cronograma prevê **dois pontos de controle** intermediários, nos quais o progresso do projeto é apresentado e avaliado.

O cronograma a seguir apresenta as datas de início e término de cada Sprint, bem como as datas das entregas do projeto.

|Evento|Data|
|------|----|
|Sprint 1|09/04 a 12/04|
|Sprint 2|12/04 a 30/04|
|**Ponto de Controle 1**|28/04|
|1ª apresentação|30/04|
|Sprint 3|01/05 a 14/05|
|Sprint 4|15/05 a 04/06|
|**Ponto de Controle 2**|02/06|
|2ª apresentação|04/06|
|Sprint 5|05/06 a 18/06|
|Sprint 6|19/06 a 27/06|
|**Entrega final do compilador**|27/06|
|Apresentação final - Entrevista|02/07|

---
## Documentação

Toda a documentação referente ao projeto pode ser visualizada na pasta `./docs`. Os documentos desenvolvidos pela equipe buscam detalhar características do projeto, e incluem:

* Uma visão geral [sobre o projeto](https://github.com/brunaalmeidasantos/G16-compiladores-projeto/blob/main/docs/sobre_o_projeto.md);
* Detalhes sobre a [gramática](https://github.com/brunaalmeidasantos/G16-compiladores-projeto/blob/main/docs/gramatica.md) do Compylador;
* O levantamento de [histórias de usuário](https://github.com/brunaalmeidasantos/G16-compiladores-projeto/blob/main/docs/historias_usuario.md) para o projeto;
* A avaliação de [riscos técnicos]() que podem ocorrer ao longo do desenvolvimento do compilador e;
* O detalhamento de todas as [Sprints](https://github.com/brunaalmeidasantos/G16-compiladores-projeto/blob/main/docs/sprints.md) concluídas pela equipe.

Além dos documentos mencionados, também foram desenvolvidas **READMEs** individuais para os principais artefatos do projeto.

---
## Como Executar

Para interagir com o projeto, navegue até o diretório raiz em seu terminal. Certifique-se de que possui as dependências necessárias instaladas: **Flex**, **Bison** e um compilador C (como o **GCC**).

Os seguintes comandos `make` estão disponíveis:

* **Compilar o projeto:**
    ```bash
    make all
    ```
    Ou simplesmente:
    ```bash
    make
    ```
    Este comando utiliza o Flex para gerar o analisador léxico (`lexer/lexer.l`), o Bison para gerar o analisador sintático (`parser/parser.y`) e o GCC para compilar os arquivos C gerados (`lex.yy.c`, `parser.tab.c`), criando o executável `compilador`.

* **Compilar e executar o compilador:**
    ```bash
    make run
    ```
    Este comando primeiro executa as etapas de compilação (equivalente a `make all`) e, em seguida, roda o `./compilador`.

* **Compilar e rodar os testes:**
    ```bash
    make test
    ```
    Este comando compila o projeto e depois executa o script de testes `python3 ./tests/test_runner.py`.

* **Limpar arquivos gerados:**
    ```bash
    make clean
    ```
    Este comando remove os arquivos gerados durante a compilação (`lex.yy.c`, `parser.tab.c`, `parser.tab.h` e o executável `compilador`).
