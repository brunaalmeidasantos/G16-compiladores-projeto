#ifndef HASH_TABLE_H
#define HASH_TABLE_H

#define TABLE_SIZE 100


typedef struct HashItem {
    char *key;
    char *value;
    struct HashItem *next;
} HashItem;

typedef struct {
    HashItem *buckets[TABLE_SIZE];
} HashTable;


HashTable *create_table();
void free_table(HashTable *table);

unsigned int hash(const char *key);
void insert(HashTable *table, const char *key, const char *value);
char *search(HashTable *table, const char *key);
void delete_key(HashTable *table, const char *key);
void print_table(HashTable *table);

#endif
