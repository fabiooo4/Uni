%{
  // Preliminar C code
  int starts_vowel(char * c);
%}

// Aliases for commonly used regex
delim 	[ \t]
ws 			{delim}+
letter 	[a-zA-Z]
word   	{letter}+

%%
{ws} { printf("%s", yytext); }
{word} { 
	if (starts_vowel(yytext)) 
		printf("%say", yytext);
	else
		printf("%s%cay", yytext+1, yytext[0]);}
. { printf("%s", yytext); }
%%

// Custom c code
int starts_vowel(char *c){
	switch(c[0]){
		case 'a':
		case 'e':
		case 'i':
		case 'o':
		case 'u':
		case 'A':
		case 'E':
		case 'I':
		case 'O':
		case 'U':
			return 1;
		default:
			return 0;
 	}
}
