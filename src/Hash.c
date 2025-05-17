#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hash.h"

unsigned int hash(const char *key) {
    unsigned int hash = 5381;
    while (*key)
        hash = ((hash << 5) + hash) + (unsigned char)(*key++);
    return hash % TABLE_SIZE;
}

HashTable *create_table() {
    HashTable *table = malloc(sizeof(HashTable));
    if (!table) return NULL;
    for (int i = 0; i < TABLE_SIZE; i++)
        table->buckets[i] = NULL;
    return table;
}

void insert(HashTable *table, const char *key, const char *value) {
    unsigned int index = hash(key);
    HashItem *new_item = malloc(sizeof(HashItem));
    new_item->key = strdup(key);
    new_item->value = strdup(value);
    new_item->next = table->buckets[index];
    table->buckets[index] = new_item;
}

char *search(HashTable *table, const char *key) {
    unsigned int index = hash(key);
    HashItem *item = table->buckets[index];
    while (item) {
        if (strcmp(item->key, key) == 0)
            return item->value;
        item = item->next;
    }
    return NULL;
}

void delete_key(HashTable *table, const char *key) {
    unsigned int index = hash(key);
    HashItem *item = table->buckets[index];
    HashItem *prev = NULL;

    while (item) {
        if (strcmp(item->key, key) == 0) {
            if (prev)
                prev->next = item->next;
            else
                table->buckets[index] = item->next;
            free(item->key);
            free(item->value);
            free(item);
            return;
        }
        prev = item;
        item = item->next;
    }
}

void free_table(HashTable *table) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        HashItem *item = table->buckets[i];
        while (item) {
            HashItem *next = item->next;
            free(item->key);
            free(item->value);
            free(item);
            item = next;
        }
    }
    free(table);
}

void print_table(HashTable *table) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        HashItem *item = table->buckets[i];
        if (item) {
            printf("Bucket[%d]: ", i);
            while (item) {
                printf("(%s: %s) -> ", item->key, item->value);
                item = item->next;
            }
            printf("NULL\n");
        }
    }
}
