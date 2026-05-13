%{
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;

int yylex();
int yyparse();
void yyerror(char const *s);
int my_pow(int base, int exp);
%}

// token is a keyword, and the token name must be the same in yacc and lex
%token INTEGER

%%
lines: lines line
     | line
     ;

line:  expr '\n' {printf("= %d\n", $1);}

expr : expr '+' expr { $$ = $1 + $3;}
     | expr '-' expr { $$ = $1 - $3;}
     | expr '*' expr { $$ = $1 * $3;}
     | expr '/' expr { $$ = $1 / $3;}
     | expr '^' expr { $$ = my_pow($1, $3);}
     | term
     ;

term : INTEGER       { $$ = $1; }
%%

void yyerror(char const *s) {
  fprintf(stderr, "Line number %d: %s\n", yylineno, s);
}

int my_pow(int base, int exp) {
  int result = 1;
  for (int i = 0; i < exp; i++) {
    result *= base;
  }
  return result;
}

int main(){
  yyparse();
  return 0;
}
