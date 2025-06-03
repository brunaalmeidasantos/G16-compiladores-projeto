# Nome do executável
TARGET = compilador

# Arquivos de entrada
LEXER = lexer/lexer.l
PARSER = parser/parser.y

# Comandos
all:
	flex $(LEXER)
	bison -d $(PARSER)
	gcc lex.yy.c parser.tab.c semantico/semantico.c -o $(TARGET)

run: all
	./$(TARGET)

test: all
	python3 ./tests/test_runner.py

test_hash: all
	gcc ./tests/test_hash.c ./src/Hash.c -o ./tests/test_simbolos
	./test_simbolos

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h $(TARGET)
