lexer grammar alphabet;

tokens {FOO, Bar, ID_KW}

fragment LETTER
    :  [a-zA-Z]
    |   // covers all characters above 0xFF which are not a surrogate
        ~[\u0000-\u00FF\uD800-\uDBFF]
        {Character.isJavaIdentifierStart(_input.LA(-1))}?
    |   // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
        [\uD800-\uDBFF] [\uDC00-\uDFFF]
        {Character.isJavaIdentifierStart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
    ;


fragment
DIGIT
    :   '0'
    |   NonZeroDigit
    ;

fragment
NonZeroDigit
    :   [1-9]
    ;

SLASH  :  '/' ;
LPAREN :  '(' ;
RPAREN :  ')' ;
LBRACK :  '[' ;
RBRACK :  ']' ;
LBRACE :  '{' ;
RBRACE :  '}' ;

// DELIM : '(' | ')' | '[' | ']' | '{' | '}' ;
