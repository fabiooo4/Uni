// Accepts all natural numbers
grammar NatNumbers;
// import does not work with java;
// import Seq;

main: nat EOF;

nat: '0' | non_zero_digit seq;
non_zero_digit:  '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9';

seq: digit seq | ;
digit: '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9';
