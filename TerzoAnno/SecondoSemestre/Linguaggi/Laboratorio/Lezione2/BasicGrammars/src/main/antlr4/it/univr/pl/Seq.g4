// Accepts sequences of numerical characters
grammar Seq;

main: seq EOF;

seq: digit seq | ;
digit: '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9';
