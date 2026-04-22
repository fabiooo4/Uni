IDENT    [a-zA-Z][a-zA-Z0-9]*
OPERATOR [+-*/]
BINARYOP "<"|">"|"=="|">="|"<="

%%
if         printf("IF\n");
else       printf("ELSE\n");
while      printf("WHILE\n");
for        printf("FOR\n");
{OPERATOR} printf("OPERATOR\n");
{BINARYOP} printf("BINARYOP\n");
{IDENT}    printf("IDENT\n");
.*         printf("Invalid keyword\n"); return -1; // Stop the program on non recognized strings
%%

// Identifiers, double, int, operators and keywords
// Recognize them and print them accordingly.
// Keywords: if, else, while, for, def. Operators: +, -, <, >, =, ==, >=, <=

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
