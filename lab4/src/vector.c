#include <stdio.h>
#include <stdlib.h>

#include "vector.h"

void vector_init(vector *v)
{
	v->names = NULL;
	v->size = 0;
	v->count = 0;
}

int vector_count(vector *v)
{
	return v->count;
}

void vector_add(vector *v, char *name)
{
	if (v->size == 0) {
		v->size = 10;
		v->names = malloc(sizeof(char*) * v->size);
		memset(v->names, '\0', sizeof(char) * v->size);
	}

	// condition to increase v->data:
	// last slot exhausted
	if (v->size == v->count) {
		v->size *= 2;
		v->names = realloc(v->names, sizeof(char*) * v->size);
	}

	v->names[v->count] = name;
	v->count++;
}

void vector_set(vector *v, int index, char *name)
{
	if (index >= v->count) {
		return;
	}

	v->names[index] = name;
}

char* vector_get(vector *v, int index)
{
	if (index >= v->count) {
		return;
	}

	char* name = v->names[index];

	return name;
}

int vector_find_by_name(vector *v, char *name)
{
    int index = -1;
	for (int i = 0; i < vector_count(v); i++) {
        if (strcmp(vector_get(v, i), name) == 0) {
            index = i;
        }
	}

	return index;
}

void vector_delete(vector *v, int index)
{
	if (index >= v->count) {
		return;
	}

	v->names[index] = NULL;

	int i, j;
	char **newarrNames = (char**)malloc(sizeof(char*) * v->count * 2);
	for (i = 0, j = 0; i < v->count; i++) {
		if (v->names[i] != NULL) {
			newarrNames[j] = v->names[i];
			j++;
		}		
	}
	free(v->names);

	v->names = newarrNames;
	v->count--;
}

void vector_free(vector *v)
{
	free(v->names);
}

int main1(void)
{
	// vector v;
	// vector_init(&v);

	// vector_add(&v, "emil");
	// vector_add(&v, "hannes");
	// vector_add(&v, "lydia");
	// vector_add(&v, "olle");
	// vector_add(&v, "erik");

	// int i;
	// printf("first round:\n");
	// for (i = 0; i < vector_count(&v); i++) {
	// 	printf("%s\n", vector_get(&v, i));
	// }

	// vector_delete(&v, 1);
	// vector_delete(&v, 3);

	// printf("second round:\n");
	// for (i = 0; i < vector_count(&v); i++) {
	// 	printf("%s\n", vector_get(&v, i));
	// }

	// vector_free(&v);

	return 0;
}