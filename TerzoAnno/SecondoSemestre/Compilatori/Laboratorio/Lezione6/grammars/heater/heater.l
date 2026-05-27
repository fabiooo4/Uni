
%{
  // Possible comands:
  // heater <room>               : selects the room
  // target temperature <value>  : sets the temperature of the selected room to the given value
  // heat on                     : turns on the heater on the selected room
  // heat off                    : turns off the heater on the selected room
  #include <stdio.h>
  #include <stdlib.h>
  #include "y.tab.h"

  int character;
%}

%option yylineno

%%
heater      { return TOKHEATER; }
heat        { return TOKHEAT; }
target      { return TOKTARGET; }
temperature { return TOKTEMPERATURE; }
on|off    { yylval.int_val = !strcmp(yytext, "on"); return STATE; }

0|[1-9]+[0-9]* { yylval.int_val = atoi(yytext); return DEGREES; }
[a-z]          { yylval.str_val = strndup(yytext, yyleng); return ROOM; }

[ \t]
\n
%%
