#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hash.h"

#define TABLE_SIZE 100

// Função de hash simples
unsigned int hash(const char *key, int table_size) {
    unsigned long int hashval = 0;
    int i = 0;
    while (hashval < (unsigned long int)-1 && i < strlen(key)) {
        hashval = hashval << 8;
        hashval += key[i];
        i++;
    }
    return hashval % table_size;
}

HashTable* create_table(void) {
    HashTable *hashtable = malloc(sizeof(HashTable));
    hashtable->size = TABLE_SIZE;
    hashtable->table = calloc(TABLE_SIZE, sizeof(HashNode*));
    for (int i = 0; i < TABLE_SIZE; i++) {
        hashtable->table[i] = NULL;
    }
    return hashtable;
}

// CORREÇÃO: A função insert foi atualizada para aceitar Simbolo*
void insert(HashTable *table, const char *key, Simbolo *value) {
    unsigned int pos = hash(key, table->size);
    HashNode *list = table->table[pos];
    HashNode *newNode = malloc(sizeof(HashNode));
    newNode->key = strdup(key);
    newNode->value = value; // Armazena o ponteiro diretamente
    newNode->next = list;
    table->table[pos] = newNode;
}

// CORREÇÃO: A função search foi atualizada para retornar Simbolo*
Simbolo* search(HashTable *table, const char *key) {
    unsigned int pos = hash(key, table->size);
    HashNode *list = table->table[pos];
    while (list != NULL) {
        if (strcmp(list->key, key) == 0) {
            return list->value; // Retorna o ponteiro para o símbolo
        }
        list = list->next;
    }
    return NULL; // Não encontrado
}

void free_table(HashTable *table) {
    if (!table) return;
    for (int i = 0; i < table->size; i++) {
        HashNode *list = table->table[i];
        while (list != NULL) {
            HashNode *temp = list;
            list = list->next;
            free(temp->key);
            // Liberar o símbolo também
            free(temp->value->nome);
            free(temp->value);
            free(temp);
        }
    }
    free(table->table);
    free(table);
}
