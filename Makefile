TARGET = compilador

CC = gcc
CFLAGS = -g -Wall -I. -I./ast -I./src -I./semantico
LDFLAGS = -lfl

LEXER = lexer/lexer.l
PARSER = parser/parser.y

SRC_FILES = src/Hash.c \
            src/globals.c \
            ast/ast.c \
            semantico/semantico.c

GENERATED_SRC = lex.yy.c parser.tab.c

all: $(TARGET)

$(TARGET): $(SRC_FILES) $(GENERATED_SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(GENERATED_SRC) $(SRC_FILES) $(LDFLAGS)

parser.tab.c parser.tab.h: $(PARSER)
	bison -d $(PARSER)

lex.yy.c: $(LEXER) parser.tab.h
	flex $(LEXER)

test: all
	python3 ./tests/test_runner.py

test_hash:
	$(CC) $(CFLAGS) ./tests/test_hash.c ./src/Hash.c -o

test_ast:
	$(CC) $(CFLAGS) ./test_ast.c ./ast/ast.c -o ./test_ast
	./test_ast

clean:
	rm -f $(TARGET) lex.yy.c parser.tab.c parser.tab.h
	rm -f ./tests/test_simbolos ./test_ast
