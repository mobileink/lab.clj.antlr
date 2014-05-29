// Clojure symbol grammar

grammar sym ;

start: id_sym ;

//id : ID_NS | ID_NAME ;  // the informal rule says '/' may not occur in ns, but the regex allows it

id_sym
    :  id_kw
    |  id_symbol
    ;

//id_kw : ID_KW ;
id_kw
    : ':' (id_ns '/')? id_name
    ;

// TODO:  '::' only allowed at start
//id_symbol : ID_SYMBOL ;
id_symbol
    : (id_ns '/')? id_name
    ;

id_ns : ID_NS ;
ID_NS
    :  CHAR_START CHAR_NS*  // reject final ':/'
    ;

id_name : ID_NAME ;
ID_NAME
    :  CHAR_START (CHAR_START | DIGIT)*  // reject final ':'
    ;

    // |  // covers all characters above 0xFF which are not a surrogate
    //     ~[\u0000-\u00FF\uD800-\uDBFF]
    //     {Character.isJavaIdentifierPart(_input.LA(-1))}?
    // |  // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
    //     [\uD800-\uDBFF] [\uDC00-\uDFFF]
    //     {Character.isJavaIdentifierPart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
    // ;

CHAR_START
    :  LETTER
    |  CHAR_SYM
    | ':'
    ;
    // |   // covers all characters above 0xFF which are not a surrogate
    //     ~[\u0000-\u00FF\uD800-\uDBFF]
    //     {!Character.isDigit(_input.LA(-1))}?
    // |   // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
    //     [\uD800-\uDBFF] [\uDC00-\uDFFF]
    //     {!Character.isDigit(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
    // ;

// CHAR_NAME
//     :  LETTER
//     |  DIGIT
//     |  CHAR_SYM
//     |  ':'
//     ;

CHAR_NS
    :  LETTER
    |  CHAR_SYM
    |  ':'
    ;

    // |  // covers all characters above 0xFF which are not a surrogate
    //     ~[\u0000-\u00FF\uD800-\uDBFF]
    //     {Character.isJavaIdentifierPart(_input.LA(-1))}?
    // |  // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
    //     [\uD800-\uDBFF] [\uDC00-\uDFFF]
    //     {Character.isJavaIdentifierPart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
    // ;

// ASCII classes
fragment
LETTER
    :  [a-zA-Z]
    ;

fragment
DIGIT
    :  [0-9]
    ;

// CHAR_SYM = printable ascii except macro chars, ','
// all:   ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
// legal: !   # $ % & '     * +   - .   :   < = > ?     \     _ `   |

fragment
CHAR_SYM
    :  [!#$%&'*+-.\<=>?_|]
    ;

WS : [ \t\r\n\u000C\u2028]+ -> skip ;

COMMENT : ';' ~[\r\n]*  -> skip ;
