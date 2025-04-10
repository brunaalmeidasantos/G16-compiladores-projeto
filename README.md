# G16 - Compilador Python para C

Repositório dedicado ao desenvolvimento do projeto do Grupo 16 para a disciplina Compiladores 1, ministrada pelo professor Sergio Freitas durante o 1º semestre de 2025, na Universidade de Brasília (UnB).


## Equipe
|Integrante|Matrícula|
|----------|---------|
|Ana Luiz Hoffmann Ferreira|202015901|
|Bruna Almeida Santos|170100626|
|Italo Bruno Avelino da Silva Melo|190133813|
|Matheus Barros do Nascimento|190126515|
|Matheus Moreira Lopes Perillo|190093421|
|Victor Augusto de Sousa Camara|221031238|

## O projeto

O projeto elaborado por nosso grupo consiste em um **compilador que traduz um subconjunto da linguagem Python para C**. A proposta é permitir que programas escritos em Python, com uma sintaxe e estruturas definidas previamente, possam ser convertidos para código C equivalente, mantendo sua lógica e funcionalidade.

O compilador está sendo desenvolvido utilizando as ferramentas **Flex** e **Bison**, e segue as principais etapas de construção de um compilador:  
- **Análise léxica**, responsável por identificar os *tokens* da linguagem;  
- **Análise sintática**, que verifica a estrutura do código com base em uma gramática livre de contexto;  
- **Análise semântica**, que valida o uso correto de variáveis, tipos e estruturas;  
- **Geração de código**, que converte o programa Python para um código C funcional.

<br>

### Organização e Cronograma do Projeto

Claro! Aqui está um texto que você pode usar no README, explicando a organização da equipe e o cronograma do projeto:

---

## Organização e Cronograma

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
|Apresentação final|30/06|


<br>

### Documentação

Toda a documentação referente ao projeto pode ser visualizada na pasta ./docs
