#ifndef CODFINAL_FROM_CI_H
#define CODFINAL_FROM_CI_H

/**
 * @brief Gera código C final a partir de um arquivo de código intermediário.
 *
 * @param arquivo_ci O caminho para o arquivo de entrada contendo o código intermediário.
 * @param arquivo_saida O caminho para o arquivo de saída .c a ser gerado.
 */
void gerar_final_de_ci(const char* arquivo_ci, const char* arquivo_saida);

#endif