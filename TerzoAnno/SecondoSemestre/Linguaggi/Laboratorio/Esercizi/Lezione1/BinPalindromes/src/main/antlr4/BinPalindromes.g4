// Implement the CF grammar for the language of binary palindromes
grammar BinPalindromes;

main: pal EOF; // Entrypoint
pal: | '0' pal '0' | '1' pal '1' | '0' | '1';
