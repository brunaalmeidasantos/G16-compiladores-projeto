# Nome do executável
TARGET = compilador

# Arquivos de entrada
LEXER = lexer/lexer.l
PARSER = parser/parser.y

# Caminho do arquivo de teste
TEST_FILE = parser/tests/tests_ok.py # caminho pra rodar os testes que passam
# TEST_FILE = parser/tests/tests_erro.py # caminho pra rodar os testes que dao erro
# TEST_FILE = parser/tests/tests_extras.py # caminho pra rodar os testes mais complexos

# Comandos
all:
	flex $(LEXER)
	bison -d $(PARSER)
	gcc lex.yy.c parser.tab.c -o $(TARGET)

run: all
	./$(TARGET) < $(TEST_FILE)

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h $(TARGET)
