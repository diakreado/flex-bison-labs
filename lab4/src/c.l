%{
#include <stdlib.h>
#include "y.tab.h"
%}

VAR [a-zA-Z][0-9a-zA-Z_]*
D [0-9]+

%%
"+" |
"-" |
"*" |
"/" |
"=" |
";" |
"{" |
"}" |
"(" |
")" { return yytext[0]; }

"while" { return WHILE_KEY; }

"int "  { return DEF_INT; }

{VAR}   { yylval.text = strdup(yytext); return VARIABLE; }

{D}     { yylval.ival = atoi(yytext); return NUM; }

(\n)    { return EOL; }

[ \t]   { }
(.)     { }

%%

#ifndef yywrap
int yywrap () { return 1; }
#endif


// "int"[ ]+{VAR}([ ]*=[ ]*{D})?";" { printf("DEF-"); ECHO; printf("-DEF"); }
// "while ("([a-zA-Z0-9 +-]+)")" { printf("WHILE-"); ECHO; printf("-WHILE "); }
// "{" { printf("open-"); ECHO; }
// ([ ]+)?{VAR}[ ]*=([ ]*({VAR}|{D})[ ]*([+-])?)+[ ]*";" { printf("OPER-"); ECHO; printf("-OPER"); }
// "}" { ECHO; printf("-close"); }
// (\n) { ECHO; }