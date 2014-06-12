lexer grammar cljLexer ;

import alphabet, literals, constants // symbols
;

// we'd like to import the symbols grammar, but modes don't work in
// imported lex grammars

////  begin symbols.g4

// lexer grammar symbols ;

// import alphabet ;

tokens {KW_SENTINEL,KW_NM,MAYBE_SYM_NS,SYM_NM,MAYBE_SYM_NM,MAYBE_KW_NS,MAYBE_KW_NM,SYM_NS,WHITESPACE,COMMENTS,BAD_SYM_TERMINAL_COLON}

// %%%%%%%%%%%%%%%%

// See below for explanation of NS_START and NM_START


// WARTS
// clojure repl allows (symbol "-1234") and '-1234
// but rejects (def -1234 5) and (def '-1234 5)
// with "First argument to def must be a Symbol"
//
// user=> (def a (symbol "-99"))
// #'user/a
// user=> a
// -99
// user=> (class a)
// clojure.lang.Symbol

// same with keywords:
// user=> :-12
// :-12
// user=> :-12/-34
// :-12/-34

// with proper syms: '-foo is ok:
// user=> (def -foo 9)
// #'user/-foo

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

BAD_SYM_COLONS_EMBEDDED
    : NM_START
        (LETTER | DIGIT | HARF | '/')*
        '::'
        (LETTER | DIGIT | HARF | '/')+
    ;

BAD_SYM_TERMINAL_COLON1
    : NM_START (LETTER | DIGIT | HARF | MACRO_TERMINATING )*
        ':/'
        (LETTER | DIGIT | HARF | MACRO_TERMINATING )*
        ':'?
        -> type(BAD_SYM_TERMINAL_COLON)
    ;

BAD_SYM_TERMINAL_COLON2
    : NM_START (LETTER | DIGIT | HARF | MACRO_TERMINATING | '/')*
        ':'
        -> type(BAD_SYM_TERMINAL_COLON)
    ;

BAD_SYM_MACRO
    : NM_START (LETTER | DIGIT | HARF | '/')*
        MACRO_TERMINATING+
        NS_START (LETTER | DIGIT | HARF | '/')*
    ;

KW_SENTINEL
    : ':'
        {
            // System.out.println("KW_SENTINEL");
        }
        -> pushMode(KW)
    ;

SYM_NS
    : NS_START (LETTER | DIGIT | HARF)*
        {_input.LA(1) == '/'}?
        -> pushMode(SYM)
    ;

// xSYM_NM_NIL_NS
//     : ('+' | '-') DIGIT (LETTER | DIGIT | HARF)*
//         {0>1;}
//     ;

MATHOP : '+' | '-' | '*' | '/' ;

SYM_NM_NIL_NS
    : (NS_START
    | ('+' | '-') ~[0-9] (LETTER | DIGIT | HARF)*
    | NS_START_NOOP (LETTER | DIGIT | HARF)*
        // {!((getText().startsWith("+")
        //         || getText().startsWith("-"))
        //     && (getText().length() > 1?
        //         Character.isDigit(getText().charAt(1))
        //         :false))
        // }?
        // {
        //     System.out.println(getText().charAt(0)
        //                        + " "
        //                        + getText().charAt(1));
        //     setType(SYM_NM);
        // }
    | '/')
        -> type(SYM_NM)
    ;

// ================================================================
mode KW;
KW_SEP : '/'
        {
            // System.out.println("KW_SEP: " + getText());
            if (_input.LA(-2) == ':') { // prevent ':/'
                RecognitionException re
                    = new LexerNoViableAltException(
                                                    this,
                                                    getInputStream(),
                                                    getCharIndex(),
                                                    new ATNConfigSet());
                notifyListeners((LexerNoViableAltException)re);
                setType(MAYBE_KW_NS);
            } else {
                setType(SLASH);
            }
        }
    ;

KW_NS
    : NS_START (LETTER | DIGIT | HARF)*
        {_input.LA(1) == '/'}?
        // {
        //     // System.out.println("KW_NS: " + getText());
        //     if (getText().endsWith(":")) {
        //         // ATNConfigSet atncfg = new ATNConfigSet();
        //         RecognitionException re
        //             = new LexerNoViableAltException(
        //                                             this,
        //                                             getInputStream(),
        //                                             getCharIndex(),
        //                                             new ATNConfigSet());
        //         notifyListeners((LexerNoViableAltException)re);
        //         setType(MAYBE_KW_NS);
        //         //         System.out.println("KW_NS LEX EXCEPTION: terminal ':' in "
        //         //                            + getText());
        //     }
        //     if (getText().indexOf("::", 1) >= 0) {
        //         if (getText().endsWith(":")) {
        //             // ATNConfigSet atncfg = new ATNConfigSet();
        //             RecognitionException re
        //                 = new LexerNoViableAltException(
        //                                                 this,
        //                                                 getInputStream(),
        //                                                 getCharIndex(),
        //                                                 new ATNConfigSet());
        //             notifyListeners((LexerNoViableAltException)re);
        //             setType(MAYBE_KW_NS);
        //         }
        //     }
        // }
    ;

// BAD_KW_NS_COLON : NS_START (LETTER | DIGIT | HARF | MACRO_TERMINATING )* ':'
//     ;

// BAD_KW_NS_MACRO : NS_START (LETTER | DIGIT | HARF | MACRO_TERMINATING )*
//     ;

KW_NM : NM_START (LETTER | DIGIT | HARF)*
        {!getText().endsWith(":")}?
        {
            // System.out.println("KW_NM: " + getText());
            if (getText().endsWith(":")) {
                // ATNConfigSet atncfg = new ATNConfigSet();
                RecognitionException re
                    = new LexerNoViableAltException(
                                                    this,
                                                    getInputStream(),
                                                    getCharIndex(),
                                                    new ATNConfigSet());
                notifyListeners((LexerNoViableAltException)re);
                setType(MAYBE_KW_NM);
                //         System.out.println("KW_NM LEX EXCEPTION: terminal ':' in "
                //                            + getText());
            }
            if (getText().indexOf("::", 1) >= 0) {
                // ATNConfigSet atncfg = new ATNConfigSet();
                RecognitionException re
                    = new LexerNoViableAltException(
                                                    this,
                                                    getInputStream(),
                                                    getCharIndex(),
                                                    new ATNConfigSet());
                notifyListeners((LexerNoViableAltException)re);
                setType(MAYBE_KW_NM);
            }
        }
        -> popMode
    ;

BAD_KW_NM_COLON : NM_START (LETTER | DIGIT | HARF | MACRO_TERMINATING )* ':'
    ;

// BAD_KW_NM_MACRO : NM_START (LETTER | DIGIT | HARF | MACRO_TERMINATING )*
//     ;

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

MATHOPx : ('+' | '-' | '*' | '/')
        {setType(MATHOP);}
        -> popMode
    ;

SYM_NM : NM_START (LETTER | DIGIT | HARF)*
        -> popMode
    ;

// BAD_SYM_NSNM_COLON : NM_START (LETTER | DIGIT | HARF | MACRO_TERMINATING )* ':'
//     ;

// BAD_SYM_NSNM_MACRO : NM_START (LETTER | DIGIT | HARF | MACRO_TERMINATING )*
//     ;

mode DIVOP;
DIVSYM : '/'
        {
            // System.out.println("DIVOP");
                setType(MATHOP);
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
// but the nm part can start with ':'
// Summary: anything beginning with ':' is a kw
// the ns part of a kw cannot start with ':', hence NS_START
// the nm part of kw and syms can start with ':', like kw, hence NM_START

// ':' can be embedded after first char (but not '::')
// to deal with this and the start char conditions,
// we use class HARF_START, which contains all allowed sym chars EXCEPT ':'
// and HARF, which adds ':' to HARF_START

fragment
NM_START : NS_START | ':' ;

fragment
NS_START
    :  LETTER
    |  HARF_START
    |   // covers all characters above 0xFF which are not a surrogate
        ~[\u0000-\u00FF\uD800-\uDBFF]
        {!Character.isDigit(_input.LA(-1))}?
    |   // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
        [\uD800-\uDBFF] [\uDC00-\uDFFF]
        {!Character.isDigit(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
    ;

fragment
NS_START_NOOP
    :  LETTER
    |  HARF_START_NOOP
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
HARF : HARF_START | ':' | '\\' ;

// HARF_START excludes ':', so we can distinguish between kws and syms
fragment
HARF_START : HARF_START_NOOP | '+' | '-' | '*' ;

fragment
HARF_START_NOOP
    : '!' | '#' | '$' | '%' | '&'
    | '.' | '<' | '=' | '>' | '\''
    | '?' | '_' | '|'
    ;

//fragment
// MACRO : MACRO_TERMINATING | MACRO_NON_TERMINATING | DELIM ;
// ascii order

// fragment
MACRO_TERMINATING : '"' | '`' | '~' | ';' | '\\' | '@' | '^' ;

// WARNING: repl behavior does not match LispReader.  The
// latter says '%' is non-terminating; the former chokes on
// e.g.  'a%b
// fragment
// MACRO_NON_TERMINATING : '#' | '%' | '\'' ;

//mode STRICT;  // no embedded '/' in syms, etc.

//mode LOOSE; // match Clojure's de facto grammar

// in clojure.lang.LispReader
// static Pattern symbolPat =
//  Pattern.compile("[:]?([\\D&&[^/]].*/)?(/|[\\D&&[^/]][^/]*)");


// %%%%%%%%%%%%%%%%


////  end symbols.g4

WS  :  [ \t\r\n\u000C]+ -> channel(WHITESPACE)
    ;

LINE_COMMENT
    :   ';' ~[\r\n]* -> channel(COMMENTS)
    ;

