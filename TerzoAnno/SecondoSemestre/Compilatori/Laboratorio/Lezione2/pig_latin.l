%%
stop                  return 0;
[aeiouAEIOU][a-zA-Z]* printf("%say", yytext);
[a-zA-Z]+             printf("%s%cay", yytext + 1, yytext[0]);
%%
// The main function can be redefined
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
