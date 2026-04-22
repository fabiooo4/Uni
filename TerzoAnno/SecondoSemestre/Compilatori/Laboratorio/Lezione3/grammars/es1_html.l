%%
"<"[^>]+">" printf("%.*s", yyleng - 2, yytext + 1);
.|\n
%%
 
// Accept a file as input
int main(int argc, char** argv) {
  if (argc > 1) {
    yyin = fopen(argv[1], "r");
  } else {
    yyin = stdin; // This is a lex predefined variable, it is the input file
  }

  // This is mandatory to call the lexer
  yylex();
  return 0;
}
