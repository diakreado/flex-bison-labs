%{
#include "./vector.h"
%}

%union {
    int ival;
    char* text;
};

%token <text> VARIABLE
%token <ival> NUM
%token EOL

%type <ival> number
%type <ival> condition

%token DEF_INT WHILE_KEY FUNC_MAIN

%start def_main


%%
def_main:   
            | EOL def_main
            | DEF_INT FUNC_MAIN '{'         { initVector(); }
                commands
            '}' def_main                    { freeVector(); }
            ;

commands:   
            | EOL commands
            | definition ';' EOL commands
            | while_cycle commands
            | operation ';' EOL commands
            ;

definition: DEF_INT VARIABLE                        { initVar($2, 0); }
            | DEF_INT VARIABLE '=' number           { initVar($2, $4); }
            ;

operation:  VARIABLE '=' number                     { setVar($1, $3); }
            | VARIABLE '=' VARIABLE                 { varSetVar($1, $3); }
            | VARIABLE '+' '+'                      { incVal($1, 1); }
            | VARIABLE '+' '=' number               { incVal($1, $4); }
            | VARIABLE '-' '-'                      { decVal($1, 1); }
            | VARIABLE '-' '=' number               { decVal($1, $4); }
            | VARIABLE '=' VARIABLE '+' number      { varAddNum($1, $3, $5); }
            | VARIABLE '=' VARIABLE '-' number      { varAddNum($1, $3, (-1)*$5); }
            | VARIABLE '=' VARIABLE '+' VARIABLE    { varAddVar($1, $3, $5); }
            | VARIABLE '=' VARIABLE '-' VARIABLE    { varSubVar($1, $3, $5); }
            ;

while_cycle: WHILE_KEY '(' VARIABLE condition ')' EOL  { startWhile($3, $4); }
             '{' EOL
             commands
             '}'                                    { endWhile(); }
             ;

condition:   '+' NUM                                { $$ = (-1) * $2; }
            | '-' NUM                               { $$ = $2; }
            ;
 
number:     NUM                                     { $$ = $1; }
            | '-' NUM                               { $$ = (-1) * $2; }
            | number '+' number                     { $$ = $1 + $3; }
            | number '-' number                     { $$ = $1 - $3; }
            | number '*' number                     { $$ = $1 * $3; }
            | number '/' number                     { $$ = $1 / $3; }        
            ;
%%


int nestedLoop = 1;
int nextLoop = 0;
vector v;

initVector()
{
    vector_init(&v);
}

freeVector()
{
    vector_free(&v);
}

initVar(char* name, int value)
{
    int index = vector_find_by_name(&v, name);
    if (index != -1) {
		printf("ERROR: redeclaration of '%s' \n", name);
        exit(1);
    }

    vector_add(&v, name);

    printf("mov DWORD PTR [rbp-%d], %d\n", vector_count(&v)*4, value);
}

setVar(char* name, int value)
{
    int index = vector_find_by_name(&v, name);
    if (index == -1) {
        printf("ERROR: '%s' was not declared in this scope \n", name);
        exit(1);
    }

    vector_set(&v, index, name);

    printf("mov DWORD PTR [rbp-%d], %d\n", (index+1)*4, value);
}

startWhile(char* name, int expr)
{
    int index = vector_find_by_name(&v, name);
    if (index == -1) {
        printf("ERROR: '%s' was not declared in this scope \n", name);
        exit(1);
    }

    printf(".L%dD%d:\n", nestedLoop+1, nextLoop);
    printf("cmp DWORD PRT [rbp-%d], %d\n", (index+1)*4, expr);
    printf("je .L%dD%d\n", nestedLoop, nextLoop);

    nestedLoop+=2;
}

endWhile()
{
    nestedLoop-=2;

    printf("jmp .L%dD%d\n", nestedLoop+1, nextLoop);
    printf(".L%dD%d:\n", nestedLoop, nextLoop);

    if (nestedLoop == 1){
        nextLoop++;
    }
}

incVal(char* name, int val)
{
    int index = vector_find_by_name(&v, name);
    if (index == -1) {
        printf("ERROR: '%s' was not declared in this scope \n", name);
        exit(1);
    }
    printf("add DWORD PTR [rbp-%d], %d\n", (index+1)*4, val);
}

decVal(char* name, int val)
{
    int index = vector_find_by_name(&v, name);
    if (index == -1) {
        printf("ERROR: '%s' was not declared in this scope \n", name);
        exit(1);
    }
    printf("sub DWORD PTR [rbp-%d], %d\n", (index+1)*4, val);
}

varAddNum(char* name1, char* name2, int num) {
    int index1 = vector_find_by_name(&v, name1);
    int index2 = vector_find_by_name(&v, name2);
    if (index1 == -1) {
        printf("ERROR: '%s' was not declared in this scope \n", name1);
        exit(1);
    }
    if (index2 == -1) {
        printf("ERROR: '%s' was not declared in this scope \n", name2);
        exit(1);
    }

    printf("mov eax, DWORD PTR [rbp-%d]\n", (index2+1)*4);
    if (num >= 0) {
        printf("add eax, %d\n", num);
    } else {
        printf("sub eax, %d\n", (-1)*num);
    }
    printf("DWORD PTR [rbp-%d], eax\n", (index1+1)*4);
}

varSetVar(char* name1, char* name2) {
    int index1 = vector_find_by_name(&v, name1);
    int index2 = vector_find_by_name(&v, name2);
    if (index1 == -1) {
        printf("ERROR: '%s' was not declared in this scope \n", name1);
        exit(1);
    }
    if (index2 == -1) {
        printf("ERROR: '%s' was not declared in this scope \n", name2);
        exit(1);
    }

    printf("mov eax, DWORD PTR [rbp-%d]\n", (index2+1)*4);
    printf("DWORD PTR [rbp-%d], eax\n", (index1+1)*4);
}

varAddVar(char* name1, char* name2, char* name3) {
    int index1 = vector_find_by_name(&v, name1);
    int index2 = vector_find_by_name(&v, name2);
    int index3 = vector_find_by_name(&v, name3);
    if (index1 == -1) {
        printf("ERROR: '%s' was not declared in this scope \n", name1);
        exit(1);
    }
    if (index2 == -1) {
        printf("ERROR: '%s' was not declared in this scope \n", name2);
        exit(1);
    }
    if (index3 == -1) {
        printf("ERROR: '%s' was not declared in this scope \n", name3);
        exit(1);
    }

    printf("mov edx, DWORD PTR [rbp-%d]\n", (index2+1)*4);
    printf("mov eax, DWORD PTR [rbp-%d]\n", (index3+1)*4);
    printf("add eax, edx\n");
    printf("mov DWORD PTR [rbp-%d], eax\n", (index1+1)*4);
}

varSubVar(char* name1, char* name2, char* name3) {
    int index1 = vector_find_by_name(&v, name1);
    int index2 = vector_find_by_name(&v, name2);
    int index3 = vector_find_by_name(&v, name3);
    if (index1 == -1) {
        printf("ERROR: '%s' was not declared in this scope \n", name1);
        exit(1);
    }
    if (index2 == -1) {
        printf("ERROR: '%s' was not declared in this scope \n", name2);
        exit(1);
    }
    if (index3 == -1) {
        printf("ERROR: '%s' was not declared in this scope \n", name3);
        exit(1);
    }

    printf("mov edx, DWORD PTR [rbp-%d]\n", (index2+1)*4);
    printf("mov eax, DWORD PTR [rbp-%d]\n", (index3+1)*4);
    printf("sub eax, edx\n");
    printf("mov DWORD PTR [rbp-%d], eax\n", (index1+1)*4);
}