# Nome do executável
TARGET = compilador

# Arquivos de entrada
LEXER = lexer/lexer.l
PARSER = parser/parser.y

# Caminho do arquivo de teste
TEST_FILE = parser/tests.py

# Comandos
all:
	flex $(LEXER)
	bison -d $(PARSER)
	gcc lex.yy.c parser.tab.c -o $(TARGET)

run: all
	./$(TARGET) < $(TEST_FILE)

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h $(TARGET)
