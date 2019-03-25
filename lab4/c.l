%{
#include <stdlib.h>
#include "y.tab.h"

#define YYSTYPE int
extern YYSTYPE yylval;    /* value of numeric token */
%}

VAR [a-zA-Z][0-9a-zA-Z_]*
D [0-9]+

%%
"int"[ ]+{VAR}([ ]*=[ ]*{D})?";" { printf("DEF-"); ECHO; printf("-DEF"); }
"while ("([a-zA-Z0-9 +-]+)")" { printf("WHILE-"); ECHO; printf("-WHILE "); }
"{" { printf("open-"); ECHO; }
([ ]+)?{VAR}[ ]*=([ ]*({VAR}|{D})[ ]*([+-])?)+[ ]*";" { printf("OPER-"); ECHO; printf("-OPER"); }
"}" { ECHO; printf("-close"); }
(\n) { ECHO; }
(.) ;
%%

#ifndef yywrap
int yywrap () { return 1; }
#endif

