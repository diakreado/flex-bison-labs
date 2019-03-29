#ifndef VECTOR_H__
#define VECTOR_H__

typedef struct vector_ {
    char** names;
    int size;
    int count;
} vector;


void vector_init(vector*);
int vector_count(vector*);
void vector_add(vector*, char*);
void vector_set(vector*, int, char*);
char* vector_get(vector*, int);
int vector_find_by_name(vector*, char*);
void vector_delete(vector*, int);
void vector_free(vector*);

#endif