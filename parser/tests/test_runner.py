# pylint: disable=undefined-variable

import subprocess
import os

# Caminho base dos testes
base = os.path.dirname(__file__)

def testar(nome_arquivo, espera_erro):
    caminho = os.path.join(base, nome_arquivo)
    print(f"Testando {nome_arquivo}...", end=" ")
    try:
        resultado = subprocess.run(
            ["./compilador"],
            stdin=open(caminho),
            capture_output=True,
            text=True
        )
        saida = resultado.stdout + resultado.stderr
        houve_erro = "Erro de sintaxe" in saida

        if houve_erro == espera_erro:
            print("[✔] OK")
        else:
            print("[✖] FALHA")
            print("--- Saída ---")
            print(saida)
    except FileNotFoundError:
        print("Compilador não encontrado. Compile com `make` antes de testar.")

# Executa os testes
testar("tests_ok.py", espera_erro=False)
testar("tests_erro.py", espera_erro=True)
testar("tests_extras.py", espera_erro=False)
