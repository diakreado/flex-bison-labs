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

"main()" {yylval.text = strdup(yytext); return FUNC_MAIN; }

(\n)    { return EOL; }

[ \t]   { }
(.)     { }

%%

#ifndef yywrap
int yywrap () { return 1; }
#endif
