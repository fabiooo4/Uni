%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

int character;
%}

%option yylineno

%%
0|[1-9]+[0-9]* { yylval=atoi(yytext); return INTEGER; }
[a-z]  { character = yytext[0]; yylval = character - 'a'; return LETTER; }

[ \t]
\n return '\n';
. return yytext[0];
%%
