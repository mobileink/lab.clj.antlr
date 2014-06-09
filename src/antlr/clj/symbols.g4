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


// for testing only. we want sym, kw ids to be parsed so we can get at them in
// the tree walker

// ID_SYMBOL
//     : ID_KW
//     | ID_SYM
//     ;

// ID_KW : ':' (ID_NS '/')? ID_NM ;
//ID_SYM: (ID_NS '/')? ID_NM ;
// end testing


// sym syntax is ill-defined between clojure code and desc
// so we have two modes strict and loose
// strict means: ns and nm have same grammar:
// no '/', no trailing ':', no internal '::'

// default: mode LOOSE allows '/' in ns part:
// symbolPat = [:]?([\\D&&[^/]].*/)?(/|[\\D&&[^/]][^/]*)

//fragment
//ID_NS : CHAR_START (LETTER | DIGIT | HARF | '/')*? ;

// here the semantic predicate prevents matching e.g. abc/def/ghi
//fragment
//ID_KW :;
// ID_KW : ':' CHAR_START (LETTER | DIGIT | HARF)* ; //'/'
    //     {getText().indexOf("::", 1) < 0}?
    //     {!(getText().endsWith(":"))}?
    // ;
        // {1<0}?
        // {System.out.println("namespace " + getText() + " may not contain '::'");}
        // {getText().indexOf("::", 1) >= 0}?
        // {getText().endsWith(":")}?
        // {System.out.println("namespace " + getText() + " may not end with ':'");}
        // {(getText().indexOf("::", 1) < 0)
        //     &&
        //     (!getText().endsWith(":"))
        // }?
        // {getText().indexOf("::", 1) != -1}?
        // {System.out.println("namespace " + getText() + " may not contain '::'");}
        // {getText().endsWith(":")}?
        // {System.out.println("namespace " + getText() + " may not end with ':'");}
        // no trailing ':'; no internal '::'
        // {' '==(char)_input.LA(1)}? ;
    // ;

// ID_KW : ':' CHAR_START (LETTER | DIGIT | HARF)*
//     ;

ID : CHAR_START (LETTER | DIGIT | HARF)*
        {if (getText().startsWith(":")) {
                System.out.println("changing type from sym to kw" + getText());
                setType(CHAR_START);
            }
        }
        // {!(getText().endsWith(":"))}?
        // {' '==(char)_input.LA(1)}? // WS
    ;

        //{System.out.println("namespace " + getText() + " may not contain '::'");}
        //{System.out.println("namespace may not end with ':'");}
        //{getText().equals("enum")}?

        // {if (getText().indexOf("::", 1) >= 0) {
        //         throw new IllegalStateException("illegal embedded '::'");
        //     }
        //        {getText().indexOf("::", 1) >= 0}?
        // {System.out.println("namespace " + getText() + " may not contain '::'");}
        // {getText().endsWith(":")}?
        // {System.out.println("namespace " + getText() + " may not end with ':'");}
 //     else
        //         if (getText().endsWith(":")) {
        //         throw new IllegalStateException("illegal trailing ':'");
        //     }
        // }
        // {System.out.println("ID '" + getText() + "' may not end with ':'");}
        // no trailing ':'; no internal '::'
        // {' '==(char)_input.LA(1)}? ;
    // ;

// fragment CHAR_START :  LETTER |  HARF |  ':'  ;
fragment
CHAR_START
    :  LETTER
    |  HARF
    |   // covers all characters above 0xFF which are not a surrogate
        ~[\u0000-\u00FF\uD800-\uDBFF]
        {!Character.isDigit(_input.LA(-1))}?
    |   // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
        [\uD800-\uDBFF] [\uDC00-\uDFFF]
        {!Character.isDigit(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
        // {Character.isJavaIdentifierStart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
    ;


// HURUF (sg. HARF) = printable ascii except macro chars, ',', numbers and letters
// in ascii order:
// all:   ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
// legal: !   # $ % & '     * +   - .   :   < = > ?     \     _    |

fragment
HARF
    : '!'  | '#' | '$' | '%' | '&'
    | '\'' | '*' | '+' | '-'
    | '.'  | ':' | '<' | '=' | '>'
    | '?' | '\\' | '_' | '|' | ']' ;

//fragment
MACRO : MACRO_TERMINATING | MACRO_NON_TERMINATING | DELIM ;
// ascii order

fragment
MACRO_TERMINATING : '"' | '`' | '~' | ';' | '\\' | '@' | '^' ;
fragment
MACRO_NON_TERMINATING : '#' | '%' | '\'' ;

SLASH  :  '/' ;
LPAREN :  '(' ;
RPAREN :  ')' ;
LBRACK :  '[' ;
RBRACK :  ']' ;

DELIM : '(' | ')' | '[' | ']' | '{' | '}' ;

mode STRICT;

// in clojure.lang.LispReader
// static Pattern symbolPat =
//  Pattern.compile("[:]?([\\D&&[^/]].*/)?(/|[\\D&&[^/]][^/]*)");

//fragment
// ID_NS : CHAR_START (LETTER | DIGIT | HARF)* ;

// here the semantic predicate prevents matching e.g. abc/def/ghi
//fragment
//ID_NM : CHAR_START (LETTER | DIGIT | HARF)* ; // {' '==(char)_input.LA(1)}? ;

