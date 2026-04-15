grammar IntNegExpr;

main : exp EOF ;

// Labels begin with # and rename each node of the ParseTree
exp : INT                       # val
    | LPAR exp ADD exp RPAR     # add
    | LPAR exp SUB exp RPAR     # sub
    | LPAR exp MUL exp RPAR     # mul
    | LPAR exp DIV exp RPAR     # div
    ;

INT  : [-]?[1-9][0-9]* | '0';
LPAR : '(' ;
RPAR : ')' ;
ADD  : '+' ;
SUB  : '-' ;
MUL  : '*' ;
DIV  : '/' ;
MOD  : '%' ;

// This rule ignores all whitespace
WS   : [ \t\n\r]+ -> skip ;
