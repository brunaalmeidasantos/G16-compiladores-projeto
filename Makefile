# Nome do executável
TARGET = compilador

# Arquivos de entrada
LEXER = lexer/lexer.l
PARSER = parser/parser.y

# Arquivos fonte
SRC_FILES = src/Hash.c src/globals.c ast/ast.c

# Comandos
all:
	flex $(LEXER)
	bison -d $(PARSER)
	gcc -I. -I./ast -I./src lex.yy.c parser.tab.c $(SRC_FILES) -o $(TARGET) -lfl
	gcc lex.yy.c parser.tab.c semantico/semantico.c -o $(TARGET)

run: all
	./$(TARGET)

test: all
	python3 ./tests/test_runner.py

test_hash: all
	gcc ./tests/test_hash.c ./src/Hash.c -o ./tests/test_simbolos
	./tests/test_simbolos

test_ast: all
	gcc ./test_ast.c ./ast/ast.c -o ./test_ast
	./test_ast

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h $(TARGET)
	rm -f ./tests/test_simbolos ./test_ast
