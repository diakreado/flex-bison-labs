%{
void handler(int lenOfElement, int massOfOne);
%}   

    int mass = 0;
    int isTrue = 1;

%%
H[2-9]?(", "|"\n") handler(1, 1);

C[2-9]?(", "|"\n") handler(1, 12);
N[2-9]?(", "|"\n") handler(1, 14);
O[2-9]?(", "|"\n") handler(1, 16);
SI[2-9]?(", "|"\n") handler(2, 28);
S[2-9]?(", "|"\n") handler(1, 32);
CL[2-9]?(", "|"\n") handler(2, 35);
SN[2-9]?(", "|"\n") handler(2, 118);

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

void handler(int lenOfElement, int massOfOne) {
    if (yytext[lenOfElement] > 49 && yytext[lenOfElement] < 58) {
        mass += massOfOne * (yytext[lenOfElement] - 48 );
    } else {
        mass += massOfOne;
    }
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

