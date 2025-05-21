# Nome do executável
TARGET = compilador

# Arquivos de entrada
LEXER = lexer/lexer.l
PARSER = parser/parser.y

# Comandos
all:
	flex $(LEXER)
	bison -d $(PARSER)
	gcc lex.yy.c parser.tab.c -o $(TARGET)

run: all
	./$(TARGET)

test: all
	python3 ./tests/test_runner.py

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h $(TARGET)
