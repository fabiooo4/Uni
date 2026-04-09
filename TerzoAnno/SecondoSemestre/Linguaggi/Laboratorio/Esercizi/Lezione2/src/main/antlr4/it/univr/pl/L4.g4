// Implement a grammar for:
// L_4 = \{ 0^n 1^n \in \{ 0,1 \}^* | n \in \mathbb{N} \}
//       \cup \{ 0^n 1^{2n} \in \{ 0,1 \}^* | n \in \mathbb{N} \}
//
// Accepted examples:
// 01, 011 in L_4
// Not accepted examples:
// 10, 0111 not in L_4
grammar L4;

main: l EOF;

l: l1 | l2;
l1: | '0' l1 '1' | l2;
l2: | '0' l2 '11';
