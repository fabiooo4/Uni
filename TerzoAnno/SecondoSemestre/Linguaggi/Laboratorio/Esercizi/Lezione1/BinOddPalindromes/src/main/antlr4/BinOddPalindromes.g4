// Implement a CF grammar for the language of odd length binary palindromes
grammar BinOddPalindromes;

main: pal EOF; // Entrypoint
pal: '0' pal '0' | '1' pal '1' | '0' | '1';
