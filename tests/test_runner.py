#!/usr/bin/env python3
# pylint: disable=undefined-variable

import subprocess
import os

# Caminho base dos testes
base = os.path.dirname(__file__)
compilador = os.path.abspath(os.path.join(base, "..", "compilador"))
lex = os.path.abspath(os.path.join(base, "..", "lex.yy.c"))

# Lista de testes (nome do arquivo e se espera erro de sintaxe)
testes_sintatico = [
    ("tests_sint_ok.py", False),
    ("tests_sint_erro.py", True),
    ("tests_sint_extras.py", False),
]

testes_lexico = [
    ("tests_lex_ok.py", False),
    ("tests_lex_erro.py", True)
]

def testar(nome_arquivo, espera_erro):
    caminho = os.path.join(base,  nome_arquivo)
    print(f"\n📄 Testando {nome_arquivo} (espera erro: {espera_erro})")

    if not os.path.exists(caminho):
        print(f"❌ Arquivo {nome_arquivo} não encontrado.")
        return

    try:
        resultado = subprocess.run(
            [compilador],
            stdin=open(caminho),
            capture_output=True,
            text=True
        )
    except Exception as e:
        print(f"❌ Erro ao executar o compilador: {e}")
        return

    saida = resultado.stdout + resultado.stderr
    houve_erro = "Erro de sintaxe" in saida or resultado.returncode != 0

    if houve_erro == espera_erro:
        print("✅ [OK] Comportamento esperado.")
    else:
        print("❌ [FALHA] Comportamento inesperado!")
        print("--- Saída do compilador ---")
        print(saida)
        print("--- Código de saída ---")
        print(f"{resultado.returncode}")

def main():
    print("\n🧪 Iniciando testes do analisador léxico...\n")

    if not os.path.exists(lex):
        print("❌ Analisador léxico não encontrado. Compile com `make` ou corrija o caminho para o arquivo 'lexer'.")
    else:
        for nome_arquivo, espera_erro in testes_lexico:
            testar(nome_arquivo, espera_erro)
        print("\n✅ Testes do analisador léxico finalizados.")

    print("\n🧪 Iniciando testes do compilador...\n")

    if not os.path.exists(compilador):
        print("❌ Compilador não encontrado. Compile com `make` ou corrija o caminho para o arquivo 'compilador'.")
    else:
        for nome_arquivo, espera_erro in testes_sintatico:
            testar(nome_arquivo, espera_erro)
        print("\n✅ Testes do compilador finalizados.")

if __name__ == "__main__":
    main()
