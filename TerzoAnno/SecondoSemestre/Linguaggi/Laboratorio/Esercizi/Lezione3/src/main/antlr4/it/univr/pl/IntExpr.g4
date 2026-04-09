grammar IntExpr;
import Nat;

main : exp EOF ;

// Labels begin with # and rename each node of the ParseTree
exp : nat                       # val
    | LPAR exp ADD exp RPAR     # add
    | LPAR exp MUL exp RPAR     # mul
    ;

LPAR : '(' ;
RPAR : ')' ;
ADD  : '+' ;
MUL  : '*' ;

// This rule ignores all whitespace
WS   : [ \t\n\r]+ -> skip ;
