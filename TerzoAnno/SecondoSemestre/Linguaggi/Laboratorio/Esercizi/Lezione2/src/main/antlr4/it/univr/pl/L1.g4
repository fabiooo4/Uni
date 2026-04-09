// Implement a grammar for:
// L_1 = \{ w \in \{ 0,1 \}^* | w contains at least 4 ones \}
//
// Accepted examples:
// 011011, 11111 in L_1
// Not accepted examples:
// 0101, 111 not in L_1
grammar L1;

main: s EOF;

s: bin '1' bin '1' bin '1' bin '1';
bin: | '0' bin | '1' bin;
