%{
void handler(int lenOfElement, int massOfOne);
%}   

    int mass = 0;
    int err = 0;

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
    if (err == 0) {
        printf(" | %d mass \n", mass);
    }
    else if (err == 3) {
        printf(" | Error - correct syntax, but incorrect lexis !!! \n");
    }
    else if (err == 2) {
        printf(" | Error - incorrect number !!! \n");
    }
    else if (err == 1) {
        printf(" | Error - incorrect syntax !!! \n");
    }
    err = 0;
    mass=0;
}


(H|C|N|O|SI|S|CL|SN)[2-9]? {
    ECHO;
    printf("!"); 
    err = 3;
}

(H|C|N|O|SI|S|CL|SN)[0-1]? {
    ECHO;
    printf("!"); 
    err = 2;
}

. {
    ECHO; 
    printf("!"); 
    err = 1;
}

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

