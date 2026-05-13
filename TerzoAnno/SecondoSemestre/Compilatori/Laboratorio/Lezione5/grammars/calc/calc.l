%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}

%option yylineno

%%
0|[1-9]+[0-9]* { yylval=atoi(yytext); return INTEGER; }

[ \t]
\n return '\n';
. return yytext[0];
%%
