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

// trailing {...}? is an antlr 4 "semantic predicate"; it must be true
// for the match to work.  in this case, the predicate means that
// these ops must be followed by whitespace if they are not part of a
// symbol; otherwise, something like (+1 2) would be parsed as (+ 1 2)
// but +1 is a valid clojure (symbol) name part try this:
// (def user/-1/ 0)
// (+ user/-1 1) => 1
ADD    :  '+' {stops.contains(Character.toString((char)_input.LA(1)))}? ;
SUB    :  '-' {stops.contains(Character.toString((char)_input.LA(1)))}? ;
MUL    :  '*' {stops.contains(Character.toString((char)_input.LA(1)))}? ;
DIV    :  '/' {stops.contains(Character.toString((char)_input.LA(1)))}? ;
EQ     :  '=' {stops.contains(Character.toString((char)_input.LA(1)))}? ;

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
// says the symbol regex is [:]?([\\D&&[^/]].*/)?(/|[\\D&&[^/]][^/]*)
// which allows any number of '/' in the namespace part.

// how does this work?  the first parse matches the regex, which puts
// all the '/' in the ns part.  but when (eventually) the symbol gets
// interned (clojure.lang.Symbol$intern), the code just looks for the
// first '/' and interns the rest.  that's why we get:

//  user=> (namespace 'a/b/c/d) => "a"
//  user=> (name 'a/b/c/d) => "b/c/d"

// so for the moment we punt and reject '/' from both namespace and name parts of symbols

ID_NS : CHAR_START (LETTER | DIGIT | HARF)* ;
// here the semantic predicate prevents matching e.g. abc/def/ghi
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
