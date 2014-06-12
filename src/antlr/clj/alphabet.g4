lexer grammar alphabet;

fragment LETTER
    :  [a-zA-Z]
    |   // covers all characters above 0xFF which are not a surrogate
        ~[\u0000-\u00FF\uD800-\uDBFF]
        {Character.isJavaIdentifierStart(_input.LA(-1))}?
    |   // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
        [\uD800-\uDBFF] [\uDC00-\uDFFF]
        {Character.isJavaIdentifierStart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
    ;

// use of fragments below forces lexer to pass token rather than char
// literal, e.g. LPAREN instead of '(' . This makes token lists easier
// to handle, since ' is special in Clojure.

fragment SLASH_FRAG  :  '/' ;
SLASH  : SLASH_FRAG  ;
fragment LPAREN_FRAG :  '(' ;
LPAREN : LPAREN_FRAG ;
fragment RPAREN_FRAG :  ')' ;
RPAREN : RPAREN_FRAG ;
fragment LBRACK_FRAG :  '[' ;
LBRACK : LBRACK_FRAG ;
fragment RBRACK_FRAG :  ']' ;
RBRACK : RBRACK_FRAG ;
fragment LBRACE_FRAG :  '{' ;
LBRACE : LBRACE_FRAG ;
fragment RBRACE_FRAG :  '}' ;
RBRACE : RBRACE_FRAG ;
// DELIM : '(' | ')' | '[' | ']' | '{' | '}' ;

fragment
DIGIT
    :   '0'
    |   NonZeroDigit
    ;

fragment
NonZeroDigit
    :   [1-9]
    ;

