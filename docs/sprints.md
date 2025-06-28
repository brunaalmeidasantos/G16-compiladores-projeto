# Documentação das Sprints

<p align = "justify">O objetivo deste documento é apresentar o planejamento, execução e conclusão das 5 Sprints realizadas pela equipe Compylador (Grupo 16).</p>

## SPRINT 1

### Objetivo da Sprint

Configurar o ambiente de trabalho de todos os membros da equipe, além de iniciar a documentação do projeto.


### Duração

+ <b>Início:</b> 09/04/2025
+ <b>Fim:</b> 12/04/2025


### Issues Definidas e Responsáveis

|Nº|Issue|Responsável(eis)|
|--|-----|-----------|
|#1|Configurar ambiente de trabalho|Todos|
|#2|Fazer documento inicial do projeto|Todos|
|#3|Elaborar 1ª versão da gramática formal do projeto|Todos|


### O que foi concluído nessa Sprint?

<p align = "justify">Todos os integrantes da equipe configuraram seus ambientes de trabalho e rodaram um projeto simples para testar seus ambientes. Também foi elaborado um documento inicial do projeto, que pode ser visualizado em:

[Documento Inicial do Projeto](https://github.com/brunaalmeidasantos/G16-compiladores-projeto/blob/main/docs/sobre_o_projeto.md)</p>

<p align = "justify">A issue #3 não foi concluída, sendo retomada na Sprint 2.</p>


### O que vem a seguir?

<p align = "justify">Dar início ao analisador léxico do projeto.</p>

<br>



## SPRINT 2

### Objetivo da Sprint

<p align = "justify">Dar continuidade à documentação do projeto, desenvolver o analisador léxico e dar início ao analisador sintático.</p>

<p align = "justify">Os artefatos desenvolvidos nas Sprints 1 e 2 foram apresentadas no Ponto de Controle 1, em 30/04.</p>


### Duração

+ <b>Início:</b> 14/04/2025
+ <b>Fim:</b> 30/04/2025


### Issues Definidas e Responsáveis

|Nº|Issue|Responsável(eis)|
|--|-----|-----------|
|#5|Analisador léxico - Tokens String e Op. lógicos|Ana Luiza|
|#6|Analisador léxico - Token Palavras Chave|Bruna|
|#7|Analisador léxico - Tokens op. condicionais e quebra de linha|Victor|
|#8|Analisador léxico - Tokens comentários e op. quantitativos|Matheus Barros|
|#9|Analisador léxico - Tokens números e identificador|Matheus Perillo|
|#10|Analisador léxico - Tokens espaço e delimitador|Italo|
|#13|Documentar os tokens atribuídos no analisador léxico com exemplos de código|Todos|
|#14|Implementar versão inicial do analisador sintático|Ana Luiza e Matheus Perillo|
|#15|Documentar estruturas do Python que serão traduzidas para C|Todos|
|#16|Escrever uma descrição geral sobre Python e C para o projeto|Matheus Barros|
|#17|Definir objetivo do projeto com exemplos de código Python a serem traduzidos para C|Bruna|


### O que foi concluído nessa Sprint?

<p align = "justify">O analisador léxico (lexer) foi concluído e foram implementadas as primeiras regras no analisador sintático. Além disso, também foram implementados os primeiros testes para garantir a consistência do projeto. Por fim, foi elaborado um documento detalhando os tokens atribuídos no analisador léxico, que pode ser visualizado em:</p>

[Gramática do Compylador](https://github.com/brunaalmeidasantos/G16-compiladores-projeto/blob/main/docs/gramatica.md)</p>


### O que vem a seguir?

<p align = "justify">Concluir o analisador sintático e iniciar o analisador semântico.</p>

<br>



## SPRINT 3

### Objetivo da Sprint

<p align = "justify">Evoluir o analisador sintático com novas produções gramaticais; Iniciar a estrutura interna do compilador (árvore sintática, tabela de símbolos) e; Dar os primeiros passos na análise semântica.</p>


### Duração

+ <b>Início:</b> 07/05/2025
+ <b>Fim:</b> 20/05/2025

### Issues Definidas e Responsáveis

|Nº|Issue|Responsável|
|--|-----|-----------|
|#22|Fazer a Árvore Sintática Abstrata (AST)|Matheus Barros|
|#23|Incrementar os testes para o parser|Ana Luiza e Matheus Perillo|
|#24|Evoluir o parser|Bruna e Italo|
|#25|Fazer a Tabela Hash|Victor|


### O que foi concluído nessa Sprint?

<p align = "justify">O analisador sintático foi evoluído e mais testes foram implementados. Além disso, foram desenvolvidas a Árvore Sintática Abstrata (AST) e a tabelas de símbolos (Hash).</p>



### O que vem a seguir?

<p align = "justify">Finalizar o analisador sintático e integrar a AST e tabela de símbolos ao projeto.</p>

<br>



## SPRINT 4

### Objetivo da Sprint

<p align = "justify">Concluir a análise sintática e semântica, integrar ao projeto a estrutura interna do compilador e implementar o módulo de geração de código intermediário. </p>

<p align = "justify">Os artefatos desenvolvidos nas Sprints 3 e 4 foram apresentadas no Ponto de Controle 2, em 04/06.</p>


### Duração

+ <b>Início:</b> 21/05/2025
+ <b>Fim:</b> 04/06/2025


### Issues Definidas e Responsáveis

|Nº|Issue|Responsável|
|--|-----|-----------|
|#30|Integrar a tabela hash ao projeto|Victor|
|#31|Otimizar a saída do parser|Todos|
|#32|Desenvolver o analisador semântico|Todos|
|#33|Limpar as branches que já tiveram merge|Todos|
|#34|Atualizar o README|Matheus Barros|


### O que foi concluído nessa Sprint?

<p align = "justify">O analisador sintático foi concluído, e foram implementadas as primeiras regras do analisador semântico, junto com testes. O README foi atualizado e o iepositório foi organizado, excluindo branches que já não eram mais utilizadas.</p>

<p align = "justify">A equipe teve dificuldades em integrar a AST ao projeto. Assim, essa tarefa foi retomada na Sprint 5.</p>


### O que vem a seguir?

<p align = "justify">Finalização do analisador semântico e geração de código intermediário e final; Encerramento do projeto.</p>

<br>



## SPRINT 5

### Objetivo da Sprint

<p align = "justify">Finalizar o analisador semântico; Implementar os módulos de geração de código intermediário e final; fazer os últimos ajustes para a entrega final do projeto. </p>

<p align = "justify">Trata-se da Sprint final, sendo finalizada com a apresentação final do projeto (entrevista), realizada em 30/06.</p>


### Duração

+ <b>Início:</b> 09/06/2025
+ <b>Fim:</b> 27/06/2025


### Issues Definidas e Responsáveis

|Nº|Issue|Responsável|
|--|-----|-----------|
|#39|Criar documento detalhando as Sprints realizadas pela equipe|Bruna|
|#40|Evoluir analisador semântico|Ana Luiza, Bruna, Matheus Perillo, Victor|
|#41|Criar gerador de código intermediário|Matheus Perillo e Victor|
|#42|Integrar a AST ao projeto|Italo e Matheus Barros|
|#43|Introduzir e testar otimizações no código intermediário|Italo|
|#44|Implementar a geração de código final|Victor|
|#45|Léxico: README.md|Ana Luiza|
|#46|Sintático: README.md|Ana Luiza|
|#47|Semântico: README.md|Bruna|
|#48|AST: README.md|Matheus Barros|
|#49|Documentar redução de escopo|Ana Luiza|


### O que foi concluído nessa Sprint?

<p align = "justify">O analisador semântico foi finalizado, e a AST foi integrada à ele. Também foram desenvolvidos os módulos de geração de código intermediário e final. Em relação à documentação, foram adicionados READMEs aos principais artefatos do projeto.</p>

<p align = "justify">Dessa forma, ao fim desta última Sprint do projeto, o compilador foi finalizado. A entrevista, que configura como apresentação final do projeto, ocorre em 02 de julho de 2025.</p>