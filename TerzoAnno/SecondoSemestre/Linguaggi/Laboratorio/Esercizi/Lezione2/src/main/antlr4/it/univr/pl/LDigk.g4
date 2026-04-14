// Implement a grammar for:
// dig = \{ 0, 1, ..., 9 \}
// L_dig = \{ (d_1, ..., d_n) | n \in \mathbb{N} \land d_i \in dig, 0 < i \le n \}
// L_dig^*
//
// Accepted examples:
// (), (1, 2,9), (1, (1, 2), (3), (), 3, 6) in L_dig
// Not accepted examples:
// (, (1, 10), (() not in L_dig
grammar LDigk;

main: paren EOF;

DIG: '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9';
paren: '(' list ')';
list: | DIG COMMA list | DIG | paren COMMA list | paren;

COMMA: ', ' | ',';
