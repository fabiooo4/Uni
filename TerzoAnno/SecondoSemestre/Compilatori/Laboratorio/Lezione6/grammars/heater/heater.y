%{ 
	#include <ctype.h> 
	#include <stdio.h>
	#include <string.h>
	
	int yylex();
	int yyparse();
	void yyerror(char const *s);

  char* room = "default";
  int state = 0; // off
  int degrees = 0;
	
	int main(){
		yyparse();
    return 0;
	}
%}

// Contains all possible types
%union{
  char* str_val;
  int   int_val;
}

// Assign the type to the corresponding token
%token <int_val> DEGREES
%token <int_val> STATE
%token <str_val> ROOM

%token TOKHEATER
%token TOKHEAT
%token TOKTARGET
%token TOKTEMPERATURE

// Starting symbol
%start commands

%%

commands : command
         | commands command

command : heater_select
        | heat_switch
        | target_set

heater_select : TOKHEATER ROOM { room = strndup($2, strlen($2)); printf("Selected room '%s'\n", room); }
heat_switch   : TOKHEAT STATE  { if (state) { printf("Heater already on"); } else { state = $2; printf("Heat turned %s in '%s'\n", state ? "on" : "off", room); } }
target_set    : TOKTARGET TOKTEMPERATURE DEGREES { degrees = $3, printf("Heater '%s' temperature set to %d°\n", room, degrees); }

%%

void yyerror(char const *s) {
  fprintf(stderr, "%s\n", s);
}
