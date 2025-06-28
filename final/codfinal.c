#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#include "codfinal.h"

// Para uma implementação simples, não vamos usar uma tabela de símbolos complexa,
// mas em um projeto real, você usaria uma para rastrear os tipos das variáveis.

void gerar_final_de_ci(const char* arquivo_ci, const char* arquivo_saida) {
    FILE *in = fopen(arquivo_ci, "r");
    if (!in) {
        fprintf(stderr, "Erro: Nao foi possivel ler o arquivo de codigo intermediario %s\n", arquivo_ci);
        return;
    }

    FILE *out = fopen(arquivo_saida, "w");
    if (!out) {
        fprintf(stderr, "Erro: Nao foi possivel criar o arquivo de saida %s\n", arquivo_saida);
        fclose(in);
        return;
    }

    // Escreve o cabeçalho padrão C no arquivo de saída
    fprintf(out, "// Codigo C gerado a partir de Codigo Intermediario\n");
    fprintf(out, "#include <stdio.h>\n");
    fprintf(out, "#include <stdbool.h>\n\n");
    fprintf(out, "int main() {\n");
    
    // Simplificação: Declarar todas as variáveis como double para acomodar int e float.
    // Uma abordagem melhor rastrearia os tipos.
    // Vamos assumir que os temporários também são double.
    fprintf(out, "\t// Declaracoes de variaveis podem ser inseridas aqui no futuro.\n");

    char linha[256];
    char arg1[100], arg2[100], arg3[100], op[10];

    // Lê o arquivo de CI linha por linha
    while (fgets(linha, sizeof(linha), in)) {
        // Tenta fazer o parse dos diferentes tipos de instrução do CI

        // Formato: resultado = arg1 op arg2 (ex: t1 = t0 + 1)
        if (sscanf(linha, "%s = %s %s %s", arg1, arg2, op, arg3) == 4) {
            fprintf(out, "\tdouble %s; // Declaracao implicita\n", arg1);
            fprintf(out, "\t%s = %s %s %s;\n", arg1, arg2, op, arg3);
        }
        // Formato: resultado = arg1 (ex: x = t1)
        else if (sscanf(linha, "%s = %s", arg1, arg2) == 2) {
            fprintf(out, "\tdouble %s; // Declaracao implicita\n", arg1);
            fprintf(out, "\t%s = %s;\n", arg1, arg2);
        }
        // Formato: label L1
        else if (sscanf(linha, "label %s", arg1) == 1) {
            fprintf(out, "%s:\n", arg1);
        }
        // Formato: goto L1
        else if (sscanf(linha, "goto %s", arg1) == 1) {
            fprintf(out, "\tgoto %s;\n", arg1);
        }
        // Formato: if_false t0 goto L1
        else if (sscanf(linha, "if_false %s goto %s", arg1, arg2) == 2) {
            fprintf(out, "\tif (!(bool)%s) goto %s;\n", arg1, arg2);
        }
        // Formato: print t0
        else if (sscanf(linha, "print %s", arg1) == 1) {
            // Assumindo double para todos os prints por simplicidade
            fprintf(out, "\tprintf(\"%%f\\n\", %s);\n", arg1);
        }
        // Adicionar outros formatos aqui (param, call, return)
    }

    fprintf(out, "\n\treturn 0;\n");
    fprintf(out, "}\n");

    fclose(in);
    fclose(out);

    printf("Codigo C final gerado com sucesso a partir do CI em: %s\n", arquivo_saida);
}