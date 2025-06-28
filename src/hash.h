#ifndef HASH_H
#define HASH_H

#include "../ast/ast.h" // Precisa da definição de Simbolo

typedef struct HashNode {
    char *key;
    Simbolo *value; // CORREÇÃO: O valor agora é um ponteiro para Simbolo
    struct HashNode *next;
} HashNode;

typedef struct HashTable {
    int size;
    HashNode **table;
} HashTable;

HashTable* create_table(void);
// CORREÇÃO: A assinatura da função insert foi atualizada.
void insert(HashTable *table, const char *key, Simbolo *value);
// CORREÇÃO: A assinatura da função search foi atualizada para retornar um Simbolo.
Simbolo* search(HashTable *table, const char *key);
void free_table(HashTable *table);

#endif
