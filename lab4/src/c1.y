
%union {
    int ival;
    char* text;
};

%token <text> VARIABLE
%token <ival> NUM
%token EOL

%type <ival> number
%type <ival> condition

%token DEF_INT WHILE_KEY

%start commands


%%
commands: 
            | EOL commands
            | definition ';' EOL commands
            | while_cycle commands
            | operation ';' EOL commands
            ;

definition: DEF_INT VARIABLE                        { setVar(0); }
            | DEF_INT VARIABLE '=' number           { setVar($4); }
            ;

operation:  VARIABLE '=' number                     { setVar($3); }
            | VARIABLE '+' '+'                      { incVal(1); }
            | VARIABLE '+' '=' number               { incVal($4); }
            | VARIABLE '=' VARIABLE '+' number      { incVal($5); }
            | VARIABLE '-' '-'                      { decVal(1); }
            | VARIABLE '-' '=' number               { decVal($4); }
            | VARIABLE '=' VARIABLE '-' number      { decVal($5); }
            ;

while_cycle: WHILE_KEY '(' condition ')' EOL        { startWhile($3); }
             '{' EOL
             commands
             '}'                                    { endWhile(); }
             ;

condition:  VARIABLE '+' NUM                        { $$ = (-1) * $3; }
            | VARIABLE '-' NUM                      { $$ = $3; }
            ;
 
number:     NUM                                     { $$ = $1; }
            | '-' NUM                               { $$ = (-1) * $2; }
            | number '+' number                     { $$ = $1 + $3; }
            | number '-' number                     { $$ = $1 - $3; }
            | number '*' number                     { $$ = $1 * $3; }
            | number '/' number                     { $$ = $1 / $3; }        
            ;
%%


int varValue = 0;

setVar(int value) {
    varValue = value;
    printf("mov DWORD PTR [rbp-4], %d\n", value);
}

int getVarVal() {
    return varValue;
}

startWhile(int expr) {
    printf(".L3:\n");
    printf("cmp DWORD PRT [rbp-4], %d\n", expr);
    printf("je .L2\n");
}

endWhile() {
    printf("jmp .L3\n");
    printf(".L2:\n");
}

incVal(int val) {
    printf("add DWORD PTR [rbp-4], %d\n", val);
}

decVal(int val) {
    printf("sub DWORD PTR [rbp-4], %d\n", val);
}

