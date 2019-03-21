%{
void handler();
%}   

    int mass = 0;
    int isTrue = 1;

%%
H[0-9]?(", "|"\n") handler();


C[0-9]?(", "|"\n") handler();
N[0-9]?(", "|"\n") handler();
O[0-9]?(", "|"\n") handler();
SI[0-9]?(", "|"\n") handler();
S[0-9]?(", "|"\n") handler();
CL[0-9]?(", "|"\n") handler();
SN[0-9]?(", "|"\n") handler();

\n { 
    if (!isTrue) {
        printf(" | Error! \n");
    }
    else {
        printf(" | %d mass \n", mass);
    }
    isTrue = 1;
    mass=0;
}

. { ECHO; printf("!"); isTrue = 0; }
%%

void handler() {
    mass+=1;
    if (yytext[yyleng-1] == 10) {
        for (int i=0; i<yyleng-1; i++) {
            printf("%c",yytext[i]);
        }
        yyless(yyleng-1);
    } else {
        ECHO; 
    }
}

#ifndef yywrap
int yywrap() { return 1; }
#endif    

main () { while (yylex()); }

