// Implement a CF grammar for the language of even length binary palindromes
grammar BinEvenPalindromes;

main: pal EOF; // Entrypoint
pal: | '0' pal '0' | '1' pal '1';
