%token NUM
%start __list


%%
__list: _list

_list: /* empty */  { $$ = 0; }
      | list        
      ;

list: NUM               { inc($1); }           
    | list ',' NUM      { inc($3); }
    | list '\n'         { print($$); $$ = $1 + 1; reset_numOfValues(); }
    | list NUM          { inc($2); }    
    ;
%%

int numOfValues = 0;
int numOfNegativeValues = 0;

inc (int val) {
  numOfValues++;
  if (val < 0) {
    numOfNegativeValues++;
  }
}

print (int numOfStr) {
  printf("%d : all = %d , neg = %d \n", numOfStr, numOfValues, numOfNegativeValues);
}

reset_numOfValues () {
  numOfValues = 0;
  numOfNegativeValues = 0;
}



