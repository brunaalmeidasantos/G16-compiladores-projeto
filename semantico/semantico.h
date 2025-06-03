// semantico/semantico.h
#ifndef SEMANTICO_H
#define SEMANTICO_H

// Inicializa a estrutura de símbolos
void inicializar_tabela();

// Registra uma nova variável na tabela de símbolos
void adicionar_variavel(const char *nome);

// Verifica se uma variável já foi declarada
int variavel_declarada(const char *nome);

// Libera a memória usada pela tabela de símbolos
void limpar_tabela();

#endif
