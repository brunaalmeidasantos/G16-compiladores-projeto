TARGET = compilador

CC = gcc
CFLAGS = -g -Wall -I. -I./ast -I./src -I./semantico
LDFLAGS = -lfl

LEXER = lexer/lexer.l
PARSER = parser/parser.y

# Lista de arquivos .c
SRC_FILES = src/Hash.c \
            src/globals.c \
            ast/ast.c \
            semantico/semantico.c \
            intermediario/gerador_ci.c  \
            final/codfinal.c

# Arquivos gerados pelo Flex/Bison
GENERATED_SRC = lex.yy.c parser.tab.c

# === MUDANÇA 1: Crie uma variável para os cabeçalhos importantes ===
HEADERS = semantico/semantico.h ast/ast.h src/globals.h src/hash.h

all: $(TARGET)

# === MUDANÇA 2: Adicione $(HEADERS) às dependências do alvo principal ===
$(TARGET): $(SRC_FILES) $(GENERATED_SRC) $(HEADERS)
	$(CC) $(CFLAGS) -o $(TARGET) $(GENERATED_SRC) $(SRC_FILES) $(LDFLAGS)

# === MUDANÇA 3: Adicione a dependência do cabeçalho semântico aqui ===
parser.tab.c parser.tab.h: $(PARSER) semantico/semantico.h
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