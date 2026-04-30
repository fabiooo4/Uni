grammar Imp;

main : prog EOF;

prog: decl exp;

// Labels begin with # and rename each node of the ParseTree
exp : SUB? type=(INT | FLOAT)    # val
    | exp MUL exp                # mul
    | exp DIV exp                # div
    | <assoc=right> exp POW exp  # pow
    | exp ADD exp                # add
    | exp SUB exp                # sub
    | exp MOD exp                # mod
    | LPAR exp RPAR              # paren
    | SUB LPAR exp RPAR          # neg
    | VAR                        # var
    ;

// decl: (VAR DECL exp SEMICOLON)* # declaration
decl: VAR DECL exp SEMICOLON decl # declaration
    |                             # nildeclaration
    ;

INT          : NAT;
fragment NAT : '0' | POS ;
fragment POS : [1-9][0-9]* ;

FLOAT             : INT '.' DIGIT+ ;
fragment DIGIT    : '0' | POSDIGIT ;
fragment POSDIGIT : [1-9] ;

// TODO: implement non numerical types
STRING              : '"' STR* '"' ;
fragment STR        : ~["\\] | STRING_ESC ;
fragment STRING_ESC : '\\' [btnfr"'\\] ;

CHAR              : '\'' CH* '\'' ;
fragment CH       : ~['\\] | CHAR_ESC ;
fragment CHAR_ESC : '\\' [btnfr'\\] ;

LPAR : '(';
RPAR : ')';

ADD  : '+';
SUB  : '-';
MUL  : '*';
DIV  : '/';
MOD  : 'mod';
POW  : '^';

VAR       : [a-zA-Z]+;
DECL      : '=';
SEMICOLON : ';';

// Ignores
WS           : [ \t\n\r]+    -> skip;
COMMENT      : '/*' .*? '*/' -> skip;
LINE_COMMENT : '//' ~[\r\n]* -> skip;
