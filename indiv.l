%{
#include <stdlib.h>
#include "y.tab.h"
%}


%%
"+" |
"-" |
"*" |
"/" |
"|" |
"(" |
")" { return yytext[0]; }




%%

#ifndef yywrap
int yywrap () { return 1; }
#endif

