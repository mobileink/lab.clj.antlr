lexer grammar symLexer;

@lexer::members { // add members to generated symParser
            String stops = " \t\n";
}


// standard namespaces
NS_CLJ_CORE : 'clojure.core' ;
NS_CLJ_LANG : 'clojure.lang' ;
// ...etc...

// specials
SPECIAL :  DEF | DEFN | OR ;
DEF     :  'def' ;
DEFN    :  'defn' ;
OR      :  'or'  ;
// ...etc...

// kernel/prelude functions
PREDEF :  LIST | MAP | CONJ ;
LIST   :  'list' ;
MAP    :  'map' ;
CONJ   :  'conj' ;

OP     :  ADD | SUB | MUL | DIV | EQ ;
ADD    :  '+' {stops.contains(Character.toString((char)_input.LA(1)))}? ;
SUB    :  '-' {stops.contains(Character.toString((char)_input.LA(1)))}? ;
MUL    :  '*' {stops.contains(Character.toString((char)_input.LA(1)))}? ;
DIV    :  '/' {stops.contains(Character.toString((char)_input.LA(1)))}? ;
EQ     :  '=' {stops.contains(Character.toString((char)_input.LA(1)))}? ;

ID_NS : CHAR_START (LETTER | DIGIT | HARF)* ;
ID_NM : CHAR_START (LETTER | DIGIT | HARF)* {' '==(char)_input.LA(1)}? ;

fragment CHAR_START :  LETTER |  HARF |  ':'  ;

fragment LETTER :  [a-zA-Z] ;
NUMERAL : DIGIT+ ;
fragment DIGIT  :  [0-9] ;

// HURUF (sg. HARF) = printable ascii except macro chars, ','
// all:   ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
// legal: !   # $ % & '     * +   - .   :   < = > ?     \     _ `   |

fragment HARF   :  [!#$%&'*+-.\<=>?_|] ;

SLASH  :  '/' ;
LPAREN :  '(' ;
RPAREN :  ')' ;
LBRACK :  '[' ;
RBRACK :  ']' ;

// SP : ' ';

WS : [ \t\r\n\u000C\u2028]+ -> skip ;

COMMENT : ';' ~[\r\n]*  -> skip ;
