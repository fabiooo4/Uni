grammar Imp;

main : prog EOF;

prog : (stmt)*;

stmt : ID ASSIGN exp                          # assign
     | IF LPAR exp RPAR LBRACE stmt RBRACE    # if
     | WHILE LPAR exp RPAR LBRACE stmt RBRACE # while
     | stmt SEMICOLON stmt                    # seq
     ;

// Labels begin with # and rename each node of the ParseTree
exp : SUB? INT                         # int
    | SUB? FLOAT                       # float
    | BOOL                             # bool
    | <assoc=right> exp POW exp        # pow
    | NOT exp                          # not
    | exp op=(MUL | DIV | MOD) exp     # mulDivMod
    | exp op=(ADD | SUB) exp           # addSub
    | exp op=(LT | LEQ | GEQ | GT) exp # cmpExp
    | exp op=(EQQ | NEQ) exp           # eqExp
    | exp op=(AND | OR) exp            # andOr
    | LPAR exp RPAR                    # paren
    | SUB LPAR exp RPAR                # neg
    | ID                               # id
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

BOOL : 'true' | 'false';

LPAR : '(';
RPAR : ')';

ADD  : '+';
SUB  : '-';
MUL  : '*';
DIV  : '/';
MOD  : 'mod';
POW  : '^';

EQQ : '=='  ;
NEQ : '!='  ;
LEQ : '<='  ;
GEQ : '>='  ;
LT  : '<'   ;
GT  : '>'   ;
NOT : 'not' ;
AND : 'and' ;
OR  : 'or'  ;

IF     : 'if'    ;
WHILE  : 'while' ;
ASSIGN : '='     ;

ID       : [a-zA-Z]+;
SEMICOLON : ';';

// Ignores
WS           : [ \t\n\r]+    -> skip;
COMMENT      : '/*' .*? '*/' -> skip;
LINE_COMMENT : '//' ~[\r\n]* -> skip;
