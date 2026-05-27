%{ 
	#include <ctype.h> 
	#include <stdio.h>
	#include <string.h>
	
	int yylex();
	int yyparse();
	void yyerror(char const *s);
	
	int main(){
		yyparse();
    return 0;
	}
%}

%token INTEGER 
%token LETTER

// Starting symbol
%start lines

%%

lines : lines line
      | line
      ;

line : expr'\n' { printf("= %d\n", $1); }
     ;
	 
expr : expr '+' term { $$ = $1 + $3; }
	   | expr '-' term { $$ = $1 - $3; }
     | term          { $$ = $1;      }
     ;
	 
term : term '*' factor { $$ = $1 * $3; }
	   | term '/' factor { $$ = $1 / $3; }
	   | factor 				 { $$ = $1;      }
     ;
	 
factor : '('expr')' { $$ = $2; }
	     | INTEGER    { $$ = $1; 	}  
       ;

%%

void yyerror(char const *s) {
  fprintf(stderr, "%s\n", s);
}
