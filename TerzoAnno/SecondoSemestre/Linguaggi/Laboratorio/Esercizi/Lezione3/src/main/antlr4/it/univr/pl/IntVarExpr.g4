grammar IntVarExpr;

main : exp EOF ;

// Labels begin with # and rename each node of the ParseTree
exp : INT               # val
    | exp MUL exp       # mul
    | exp DIV exp       # div
    | exp ADD exp       # add
    | exp SUB exp       # sub
    | exp MOD exp       # mod
    | LPAR exp RPAR     # paren
    | SUB LPAR exp RPAR # neg

    | VAR               # var
    | VAR DECL exp      # declaration
    | exp COMP exp      # composition
    ;

INT  : [-]?[1-9][0-9]* | '0';
LPAR : '(';
RPAR : ')';
ADD  : '+';
SUB  : '-';
MUL  : '*';
DIV  : '/';
MOD  : 'mod';

VAR  : [a-zA-Z]*;
DECL : '=';
COMP : ';';

// This rule ignores all whitespace
WS   : [ \t\n\r]+ -> skip ;
