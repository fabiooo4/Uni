// Implement a grammar for:
// L_2 = \{ swvb | s,v \in \{ 0,1 \} \land w \in \{ 0,1,_ \}^* \land w cannot contain two adjacent _ \}
//
// Accepted examples:
// 01b, 0_1_01b in L_2
// Not accepted examples:
// 0_b, 10__0b not in L_2
grammar L2;

main: s EOF;

s: 'placeholder';
