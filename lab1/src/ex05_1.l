int is_true = 1;

%%
(1){3} { printf("11\n1");}
\n ;
%%

#ifndef yywrap
int yywrap() { return( 1 ); }
#endif

main() { while( yylex() ); }
