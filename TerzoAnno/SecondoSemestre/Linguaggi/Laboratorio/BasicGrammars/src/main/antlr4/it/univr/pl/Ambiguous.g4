grammar Ambiguous;

// accepts var anyidentifier
main: VAR ' ' ID EOF | exp;

// VAR needs to be before ID because it needs to be matched first
// otherwise 'var' will be matched as an ID
VAR: 'var';
ID: [a-z]+ ;


// Here the grammar is ambiguous because '2+3*5' can be parsed by
// executing first the addition or firs the multiplication.
// Antlr in this case picks the first derivation it finds,
// in this case MUL comes before ADD so it gets picked and multiplications
// will have precedence
exp: NAT | exp MUL exp | exp ADD exp;
ADD: '+';
MUL: '*';
NAT: '0' | [1-9][0-9]*;

// ANTLR Assumes NO LEFT RECURSION
