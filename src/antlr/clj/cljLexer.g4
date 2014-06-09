lexer grammar cljLexer ;

tokens {KW_NM}

@lexer::members {
            public static final int WHITESPACE = 3;
            public static final int COMMENT = 5;
            public static final String stops = " \t\n";
}

import alphabet, literals ;

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

// ':' handling:
// PASS:  'a', 'a:b', 'a:b:c:z', ':a', ':a:b', ':a:b:c:z' etc.
// PASS:  'a:b/c', 'a/b:c', 'a:b/c:d' etc.
// FAIL:  ':a:', ':a:b:', ':a/b:' etc. (no trailing ':')

// PASS:  '::a', '::a:b', etc.
// FAIL:  '::a/b', '::a/b:c, '::a:b/c', etc.
// FAIL:  ':::a', ':a::b' ':a/b::c' etc. (no embedded '::')

// STRATEGY: we detect these violations in the lexer using actions.
// We could use predicates, but then the strings would not
// be tokenized the way we want.
// E.g. we want 'a::b' to be tokenized as is, but flagged as illegal,
// With predicates it would be tokenized as 'a:' (illegal) plus ':b' (legal)
// so e.g. a::b: will trigger two exception messages

// In other words, we want to recognize a class of known violations
// as "bad tokens" instead of trying to find some partial recog.
// this makes it easier for the user to see what's wrong.

// NOTE: we could do the same for other "stop" chars,
// like '@', '%', etc - syms that are not in the
// HARF class (see below).

KW_SENTINEL
    : ':'
        // {System.out.println("KW_SENTINEL");}
        -> pushMode(KW)
    ;

SYM_NS
    : SYM_START (LETTER | DIGIT | HARF)*
        {_input.LA(1) == '/'}?
        // {
        //     // System.out.println("SYM_NS: " + getText());
        //     if (getText().endsWith(":")) {
        //         System.out.println("SYM_NS LEX EXCEPTION: terminal ':' in "
        //                            + getText());
        //     }
        //     if (getText().indexOf("::", 1) >= 0) {
        //         System.out.println("SYM_NS LEX EXCEPTION: embedded '::' in "
        //                            + getText());
        //     }
        // }
        -> pushMode(SYM)
    ;
SYM_NM : SYM_START (LETTER | DIGIT | HARF)*
        // {
            // System.out.println("SYM_NM: " + getText());
            // TODO: throw ANTLR errors
            // if (getText().endsWith(":")) {
            //     System.out.println("SYM_NM LEX EXCEPTION: terminal ':' in "
            //                        + getText());
            // }
            // if (getText().indexOf("::", 1) >= 0) {
            //     System.out.println("SYM_NM LEX EXCEPTION: embedded '::' in "
            //                        + getText());
            // }
        // }
        // TODO:  allow single '/' as nm
    | '/'
    ;

// ================================================================
mode KW;
KW_NS
    : SYM_START (LETTER | DIGIT | HARF)*
        {_input.LA(1) == '/'}?
        // {
        //     // System.out.println("KW_NS: " + getText());
        //     if (getText().endsWith(":")) {
        //         System.out.println("KW_NS LEX EXCEPTION: terminal ':' in "
        //                            + getText());
        //     }
        //     if (getText().indexOf("::", 1) >= 0) {
        //         System.out.println("KW_NS LEX EXCEPTION: embedded '::'"
        //                            + getText());
        //     }
        // }
        // TODO: check for embedded '::'
        // -> pushMode(KW)
    ;
KW_SEP : '/' -> type(SLASH);
// TODO: handle single '/' as name part, as below for syms
KW_NM : KW_START (LETTER | DIGIT | HARF)*
        // {
        //     // System.out.println("KW_NM: " + getText());
        //     if (getText().endsWith(":")) {
        //         System.out.println("KW_NM LEX EXCEPTION: terminal ':' in "
        //                            + getText());
        //     }
        //     if (getText().indexOf("::", 1) >= 0) {
        //         System.out.println("KW_NM LEX EXCEPTION: embedded '::' in "
        //                            + getText());
        //         // TODO: throw error
        //     }
        // }
        -> popMode
        // TODO: check for embedded '::'
        // TODO: detect ::a make a the nm, not :a
    ;

// ID_NS :     CHAR_START (LETTER | DIGIT | HARF)* '/' ;

// ================================================================
mode SYM;
SYM_SEP
    : '/'
        {_input.LA(1) == '/'}? // e.g. clojure.core//
        {
            // System.out.println("SYM_SEP: " + getText());
            setType(SLASH);
        }
        -> mode(DIVOP)
    ;
// if the SYM_SEP predicate is false, the whole match fails
// so we need the same prod again, without the predicate
// to match in that case, e.g.  a/b
SYM_SEP2
    : '/'
        {
            // System.out.println("SYM_SEP: " + getText());
            setType(SLASH);
        }
    ;

SYM_NMX
    : (
            KW_START (LETTER | DIGIT | HARF)*
            {
                // System.out.println("SYM_NMX: " + getText());
                setType(SYM_NM);
            }
            // TODO:  allow single '/' as nm
        // | '/'
        //     {
        //         System.out.println("SYM_NMX: " + getText());
        //         setType(SYM_NM);
        //     }
        ) -> popMode
    ;

mode DIVOP;
DIV : '/'
        {
            // System.out.println("DIVOP");
                setType(SYM_NM);
        }
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
    | '?' | '\\' | '_' | '|'
    ;

//fragment
// MACRO : MACRO_TERMINATING | MACRO_NON_TERMINATING | DELIM ;
// ascii order

// fragment
// MACRO_TERMINATING : '"' | '`' | '~' | ';' | '\\' | '@' | '^' ;

// WARNING: repl behavior does not match LispReader.  The
// latter says '%' is non-terminating; the former chokes on
// e.g.  'a%b
// fragment
// MACRO_NON_TERMINATING : '#' | '%' | '\'' ;

WS  :  [ \t\r\n\u000C]+ -> channel(WHITESPACE)
    ;

LINE_COMMENT
    :   ';' ~[\r\n]* -> channel(COMMENT)
    ;

//mode STRICT;  // no embedded '/' in syms, etc.

//mode LOOSE; // match Clojure's de facto grammar

// in clojure.lang.LispReader
// static Pattern symbolPat =
//  Pattern.compile("[:]?([\\D&&[^/]].*/)?(/|[\\D&&[^/]][^/]*)");

