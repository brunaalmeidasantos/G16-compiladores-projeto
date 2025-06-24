// semantico/semantico.h
#ifndef SEMANTICO_H
#define SEMANTICO_H

void inicializar_tabela_simbolos();
void finalizar_tabela_simbolos();

void declarar_variavel(const char* nome);
int verificar_variavel_declarada(const char* nome);

void erro_semantico(const char* mensagem);

#endif
