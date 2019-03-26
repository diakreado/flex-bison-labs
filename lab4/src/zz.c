#include <stdio.h>

/* ------ Define external objects ------ */

int yydebug = 0;	/* To trace parser, set yydebug = 1     */
			/* ... and call yacc with options -vtd  */
			/* To not trace, set yydebug = 0
			/* ... and call yacc with option -d     */

/* You can use "yyerror" for your own messages */
yyerror (char *s) 
{ 
	fprintf( stderr, "?-%s\n", s ); 
}

/* ------ Define starting point ------ */

main () 
{ 
	printf("push rbp\n");
	printf("mov rbp, rsp\n");
	int ret = yyparse(); 
	printf("pop rbp\n");
	printf("ret\n");
	return ret;
}
