// Implement a grammar for:
// L_3 = \{ a^i b^l c^k \in \{ a,b,c \}^* | i, l, k \in \mathbb{N} \land i + l = k \}
//
// Accepted examples:
// abcc, bc in L_3
// Not accepted examples:
// abbcc, c not in L_3
grammar L3;

main: a EOF;

a: 'a' a 'c' | b;
b: | 'b' b 'c';
