lexer grammar symbols;

import alphabet;

// @lexer::members { // add members to generated symParser
//             String stops = " \t\n";
// }


// symbol = (<namespace-id> '/')?  <name>

// this structure is recognized by the parser - see rule
// id_symbol. the lexer recognizes <namespace-id> and <name> tokens,
// (as ID_NS and IS_NM, respectively) but not symbols

// the informal clojure spec (http://clojure.org/reader) does not
// match the operational semantics defined by the code itself.  for
// example, the spec says "'/' has special meaning, it can be used
// once in the middle of a symbol to separate the namespace from the
// name, e.g. my-namespace/foo."  But the code
// (https://github.com/clojure/clojure/blob/master/src/jvm/clojure/lang/LispReader.java)
// says the symbol regex is

//       [:]?([\\D&&[^/]].*/)?(/|[\\D&&[^/]][^/]*)

// which allows any number of '/' in the namespace part.

// but here's the problem.  the first parse matches the regex, which
// puts all the '/' in the ns part.  but when (after some other
// checks) the symbol gets interned (clojure.lang.Symbol$intern), the
// code just looks for the first '/' and interns the rest.  I think
// that's why we get:

//  user=> (namespace 'a/b/c/d) => "a"
//  user=> (name 'a/b/c/d) => "b/c/d"

// so for the moment we punt and reject '/' from both namespace and name parts of symbols


// NB:  unicode char syntax not allowed in symbols? i.e. a/u0064 is illegal as a symbol


// identifiers limited to ascii???

ID_NS : CHAR_START (LETTER | DIGIT | HARF)* ;
// here the semantic predicate prevents matching e.g. abc/def/ghi
ID_NM : CHAR_START (LETTER | DIGIT | HARF)* {' '==(char)_input.LA(1)}? ;
fragment CHAR_START :  LETTER |  HARF |  ':'  ;

// HURUF (sg. HARF) = printable ascii except macro chars, ',', numbers and letters
// in ascii order:
// all:   ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
// legal: !   # $ % & '     * +   - .   :   < = > ?     \     _    |

fragment HARF
    : '!'  | '#' | '$' | '%' | '&'
    | '\'' | '*' | '+' | '-'
    | '.'  | ':' | '<' | '=' | '>'
    | '?' | '\\' | '_' | '|' | ']' ;

fragment
MACRO : MACRO_TERMINATING | MACRO_NON_TERMINATING | DELIM ;
// ascii order
MACRO_TERMINATING : '"' | '`' | '~' | ';' | '\\' | '@' | '^' ;

MACRO_NON_TERMINATING : '#' | '%' | '\'' ;

SLASH  :  '/' ;
LPAREN :  '(' ;
RPAREN :  ')' ;
LBRACK :  '[' ;
RBRACK :  ']' ;

DELIM : '(' | ')' | '[' | ']' | '{' | '}' ;


// fragment LETTER
//     :  [a-zA-Z]
//     |   // covers all characters above 0xFF which are not a surrogate
//         ~[\u0000-\u00FF\uD800-\uDBFF]
//         {Character.isJavaIdentifierStart(_input.LA(-1))}?
//     |   // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
//         [\uD800-\uDBFF] [\uDC00-\uDFFF]
//         {Character.isJavaIdentifierStart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
//     ;

// NUMERAL : DIGIT+ ;
//fragment DIGIT  :  [0-9] ;
// DIGIT defined in literals.g4

// SP : ' ';

// WS : [ \t\r\n\u000C\u2028]+ -> skip ;

// COMMENT : ';' ~[\r\n]*  -> skip ;
