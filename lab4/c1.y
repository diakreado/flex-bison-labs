%token NUM CONDITION BODY DEFINITION WHILE_KEY
%start __list


%%
__list: _list

_list: /* empty */  { $$ = 0; }
      | list        
      ;

list: NUM               {  }           
    | list ',' NUM      {  }
    | list '\n'         { print($$); $$ = $1 + 1; }
    | list NUM          {  }    
    ;
%%

int numOfValues = 0;
int numOfNegativeValues = 0;

print (int numOfStr) {
  printf("%d : all = %d , neg = %d \n", numOfStr, numOfValues, numOfNegativeValues);
}



