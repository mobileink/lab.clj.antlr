lexer grammar cljLexer ;

tokens {KW_NM}

@lexer::members {
            public static final int WHITESPACE = 3;
            public static final int COMMENTS = 5;
            // public static final int KW_MODE = DEFAULT_MODE + 1;
            public static final String stops = " \t\n";
}

// import
//         symbols
//         // literals,
//         // identifiers
//     ;

// antlr's import doesn't seem to work if text refers to @lexer
// members stuff so we must include ws and comments directly:


// ID_KW : ':' CHAR_START (LETTER | DIGIT | HARF)*
//     ;


// See below for explanation of SYM_START and KW_START

// embedded '::' and final ':' are handled by the parser

KW_SENTINEL
    : ':'
        {System.out.println("KW_SENTINEL");}
        -> pushMode(KW)
    ;

SYM_NS
    : SYM_START (LETTER | DIGIT | HARF)*
        {_input.LA(1) == '/'}?
        {System.out.println("SYM_NS: " + getText());}
        -> pushMode(SYM)
    ;
SYM_NM : SYM_START (LETTER | DIGIT | HARF)*
        {System.out.println("SYM_NM: " + getText());}
        // -> popMode
    ;

// ================================================================
mode KW;
KW_NS
    : SYM_START (LETTER | DIGIT | HARF)*
        {_input.LA(1) == '/'}?
        {System.out.println("KW_NS: " + getText());}
        // TODO: check for embedded '::'
        // -> pushMode(KW)
    ;
KW_SEP : '/' ;
KW_NM : KW_START (LETTER | DIGIT | HARF)*
        {System.out.println("KW_NM: " + getText());}
        -> popMode
        // TODO: check for embedded '::'
        // TODO: detect ::a make a the nm, not :a
    ;


// ID_NS :     CHAR_START (LETTER | DIGIT | HARF)* '/' ;

// ================================================================
mode SYM;
SYM_SEP : '/' ;
SYM_NMX : KW_START (LETTER | DIGIT | HARF)*
        {System.out.println("SYM_NM: " + getText());
        setType(SYM_NM);}
        -> popMode
    ;


mode DEFAULT_MODE;
// ID_NM :     CHAR_START (LETTER | DIGIT | HARF)*
//         {
//             System.out.println("SYM_NM: " + getText());
//             if (getText().startsWith(":")) {
//                 // System.out.println("changing type from sym to kw" + getText());
//                 setType(KW_NM);
//                 //         // set mode to SYM mode
//                 //         //
//             }
//         }
//     ;


// ======== START CHARS ========
// Syntax of kws:  ':' (ns '/')? nm
// legal: :a/:b  illegal:  ::a/b
// the ns part cannot start with ':', but the nm part can
// ::a is legal, with nm part a, implicit ns part is current ns

// Syntax of syms:  (ns '/')? nm
// here ns cannot start with ':' since that would make it a kw
// but the nm part can
// Summary: anything beginning with ':' is a kw, hence KW_START
// the ns part of a kw cannot start with ':', hence SYM_START
// the nm part of kw and syms can start with ':', like kw, hence KW_START

// ':' can be embedded after first char (but not '::')
// to deal with this and the start char conditions,
// we use class HARF_START, which contains all allowed sym chars EXCEPT ':'
// and HARF, which adds ':' to HARF_START

fragment
KW_START : SYM_START | ':' ;

fragment
SYM_START
    :  LETTER
    |  HARF_START
    |   // covers all characters above 0xFF which are not a surrogate
        ~[\u0000-\u00FF\uD800-\uDBFF]
        {!Character.isDigit(_input.LA(-1))}?
    |   // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
        [\uD800-\uDBFF] [\uDC00-\uDFFF]
        {!Character.isDigit(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
        // {Character.isJavaIdentifierStart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
        // {System.out.println("SYM_START: " + getText());}
    ;


// HURUF (sg. HARF) = printable ascii except macro chars, ',', numbers and letters
// in ascii order:
// all:   ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
// legal: !   # $ % & '     * +   - .   :   < = > ?     \     _    |

fragment
HARF : HARF_START | ':' ;

// HARF_START excludes ':', so we can distinguish between kws and syms
fragment
HARF_START
    : '!'  | '#' | '$' | '%' | '&'
    | '\'' | '*' | '+' | '-'
    | '.'  | '<' | '=' | '>'
    | '?' | '\\' | '_' | '|' | ']'
    ;

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

//mode STRICT;

// in clojure.lang.LispReader
// static Pattern symbolPat =
//  Pattern.compile("[:]?([\\D&&[^/]].*/)?(/|[\\D&&[^/]][^/]*)");

//fragment
// ID_NS : CHAR_START (LETTER | DIGIT | HARF)* ;

// here the semantic predicate prevents matching e.g. abc/def/ghi
//fragment
//ID_NM : CHAR_START (LETTER | DIGIT | HARF)* ; // {' '==(char)_input.LA(1)}? ;



fragment
LETTER
    :  [a-zA-Z]
    |   // covers all characters above 0xFF which are not a surrogate
        ~[\u0000-\u00FF\uD800-\uDBFF]
        {Character.isJavaIdentifierStart(_input.LA(-1))}?
    |   // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
        [\uD800-\uDBFF] [\uDC00-\uDFFF]
        {Character.isJavaIdentifierStart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
        // {System.out.println("LETTER: " + getText());}
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



WS  :  [ \t\r\n\u000C]+ // -> channel(WHITESPACE)
    ;

LINE_COMMENT
    :   ';' ~[\r\n]* // -> channel(COMMENTS)
    ;
