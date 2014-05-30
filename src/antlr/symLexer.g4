lexer grammar symLexer;

DEF : 'def' ;

ID_NS : CHAR_START (LETTER | DIGIT | HARF)* ;
ID_NM : CHAR_START (LETTER | DIGIT | HARF)* {' '==(char)_input.LA(1)}? ;

fragment CHAR_START :  LETTER |  HARF |  ':'  ;

fragment LETTER :  [a-zA-Z] ;
fragment DIGIT  :  [0-9] ;
fragment HARF   :  [!#$%&'*+-.\<=>?_|] ;


DIV    :  '/' ;
LPAREN :  '(' ;
RPAREN :  ')' ;

// SP : ' ';

WS : [ \t\r\n\u000C\u2028]+ -> skip ;

COMMENT : ';' ~[\r\n]*  -> skip ;
