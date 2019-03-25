%token NUM CONDITION BODY DEF_INT WHILE_KEY VARIABLE EOL
%start commands


%%
commands: definition ';' EOL commands { printf("!!!"); }
          | while_cycle
          ;

definition: DEF_INT VARIABLE
            | DEF_INT VARIABLE '=' expression
            ;

while_cycle: WHILE_KEY '(' expression ')'
             ;


expression: NUM
            | VARIABLE
            | expression '+' expression    
            | expression '-' expression    
            | expression '*' expression    
            | expression '/' expression            
            ;
%%

int numOfValues = 0;
int numOfNegativeValues = 0;

print (int numOfStr) {
    printf("%d : all = %d , neg = %d \n", numOfStr, numOfValues, numOfNegativeValues);
}



