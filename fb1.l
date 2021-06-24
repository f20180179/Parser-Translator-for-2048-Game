%{
# include "fb1.tab.h"
%}

extern "C" int yylex();
%option noyywrap

%%
"ADD" return YADD;
"SUBTRACT" return YSUB;
"MULTIPLY" return YMUL;
"DIVIDE" return YDIV;
"LEFT" return YLEFT;
"RIGHT" return YRIGHT;
"UP" return YUP;
"DOWN" return YDOWN;
"ASSIGN" return ASSIGN;
"TO" return TO;
"VAR" return VAR;
"IS" return IS;
"VALUE" return VALUE;
"IN" return IN;
\. return STOP;
, return COMMA;

[0-9]+ { yylval.num = atoi(yytext); 
            //printf("%d\n", yylval.num); 
            return NUMBER; }
[A-Za-z0-9]+ { yylval.str = (char *)malloc((yyleng+1)*sizeof(char));
                    strncpy(yylval.str, yytext, yyleng);
                    yylval.str[yyleng+1] = '\0';
            printf("%s\n", yylval.str); 
            return STRING; }
\n     { return EOL; }
[ \t]  { /* ignore whitespace */ }
.      { printf("Mystery character %c\n", *yytext); }
%%