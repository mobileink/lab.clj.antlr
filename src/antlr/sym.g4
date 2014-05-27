// Clojure symbol grammar

grammar sym ;

@lexer::members {
public static final int WHITESPACE = 3;
public static final int COMMENTS = 5;
}

// the tokens statement prevents warnings about "implicit definition of token 'FOO' in parser"
// it's needed even though the included lex grammar defines them
// tokens {STRING, NUMBER, CHARACTER, NIL, BOOLEAN, KEYWORD, PARAM_NAME}
// import lex_wscomments ;

start: ID_SYMBOL*;

// http://clojure.org/reader
// Symbols begin with a non-numeric character and can contain
// alphanumeric characters and *, +, !, -, _, and ? (other characters
// will be allowed eventually, but not all macro characters have been
// determined). '/' has special meaning, it can be used once in the
// middle of a symbol to separate the namespace from the name,
// e.g. my-namespace/foo. '/' by itself names the division function. '.'
// has special meaning - it can be used one or more times in the middle
// of a symbol to designate a fully-qualified class name,
// e.g. java.util.BitSet, or in namespace names. Symbols beginning or
// ending with '.' are reserved by Clojure. Symbols containing / or . are
// said to be 'qualified'. Symbols beginning or ending with ':' are
// reserved by Clojure. A symbol can contain one or more non-repeating
// ':'s.

// code:  src/jvm/clojure/lang/LispReader.java
// static Pattern symbolPat = Pattern.compile("[:]?([\\D&&[^/]].*/)?(/|[\\D&&[^/]][^/]*)");

// Java regex syntax: http://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html
// \D = non-digit = [^0-9]
// ANTLR:  ~[0-9]
// [a-z&&[^bc]] 	a through z, except for b and c: [ad-z] (subtraction)
// ANTLR: [ad-z]

// so [\\D&&[^/]] matches any non-digit EXCEPT '/', i.e. non-digits-minus-/
// ANTLR:  ~[0-9/]
// last clause (/|[\\D&&[^/]][^/]*) means
//  "either '/' OR one non-digits-minus-/, followed by zero or more any-minus-/
// ANTLR: (('/' | ~[0-9/])[^/]*)

// let STARTCHAR = any char that is neither a digit nor '/'
//
// then "[:]?([\\D&&[^/]].*/)?(/|[\\D&&[^/]][^/]*)" means:
//
// maybe start with ':' [:]?
//     ANTRL: ':'?
// then maybe: group 1 (ns part): ([\\D&&[^/]].*/)?
//     STARTCHAR followed by any number of any-char, followed by '/'
//     ANTLR: (~[0-9/].*/)?
// then finally group 2 (local name part): (/|[\\D&&[^/]][^/]*)
//     either
//         '/'
//     OR
//         STARTCHAR followed by any number of any char excluding '/'
//     ANTLR: (('/' | ~[0-9/])~[/]*)

// this gives us:

// RES : ';PASS' | ';FAIL' ;

// SYMBOL : Identifier ;
// SYMBOL : ':'? PFX? NAME ;
// PFX    : NS '/' ;
// NS     : STARTCHAR ~[()[\]{}]* ;
// NAME   : '/' | STARTCHAR+ ; // .*? ;
// STARTCHAR: ~[0-9/] ;


// delims

DELIM : LPAREN | RPAREN | LBRACE | RBRACE | LBRACK | RBRACK ;

LPAREN          : '(';
RPAREN          : ')';
LBRACE          : '{';
RBRACE          : '}';
LBRACK          : '[';
RBRACK          : ']';

// macro chars - see clojure.lang.LispReader

MACRO_CHAR : MC_QUOTE | MC_QUOTESYN | MC_UNQUOTE | MC_COMMENT | MC_CHARLIT | MC_DEREF | MC_META | MC_DISPATCH | MC_STRING | MC_ARG ;

MC_QUOTE    : '\'' ;
MC_QUOTESYN : '`'  ;
MC_UNQUOTE  : '~'  ;
MC_COMMENT  : ';'  ;
MC_CHARLIT  : '\\' ;
MC_DEREF    : '@'  ;
MC_META     : '^'  ;
MC_DISPATCH : '#'  ;
MC_STRING   : '"'  ;
MC_ARG      : '%'  ;

// dispatch macro chars  -  micro-syntax for regex patters, var quote, etc.

DISPATCH_MACRO_CHAR = DMC_META | DMC_VAR | DMC_REGEX | DMC_FN | DMC_SET | DMC_EVAL | DMC_COMMENT ;

DMC_META    : '^'  ;
DMC_VAR     : '\'' ;
DMC_REGEX   : '"'  ;
DMC_FN      : '('  ;
DMC_SET     : '{'  ;
DMC_EVAL    : '='  ;   //  unsupported?  #=(+ 1 2) => 3
DMC_COMMENT : '!'  ;
// '<' = UnreadableReader
// '_' = DiscardReader


COMMA           : ',';
DOT             : '.';

// §3.12 Operators

ASSIGN          : '=';
GT              : '>';
LT              : '<';
BANG            : '!';
TILDE           : '~';
QUESTION        : '?';
COLON           : ':';
EQUAL           : '==';
LE              : '<=';
GE              : '>=';
NOTEQUAL        : '!=';
AND             : '&&';
OR              : '||';
INC             : '++';
DEC             : '--';
ADD             : '+';
SUB             : '-';
MUL             : '*';
DIV             : '/';
BITAND          : '&';
BITOR           : '|';
CARET           : '^';
MOD             : '%';

ADD_ASSIGN      : '+=';
SUB_ASSIGN      : '-=';
MUL_ASSIGN      : '*=';
DIV_ASSIGN      : '/=';
AND_ASSIGN      : '&=';
OR_ASSIGN       : '|=';
XOR_ASSIGN      : '^=';
MOD_ASSIGN      : '%=';
LSHIFT_ASSIGN   : '<<=';
RSHIFT_ASSIGN   : '>>=';
URSHIFT_ASSIGN  : '>>>=';

// sym regex: [:]?([\\D&&[^/]].*/)?(/|[\\D&&[^/]][^/]*)

ID_SYMBOL
    :  ID_KW
    |  ID_NAME
    |  ID_QUALIFIED_NAME
    ;

ID_KW
    : [:] (ID_NS '/')? ID_NAME
    ;

ID_NS
    :  ID_START_CHAR ID_NS_CHAR*
    ;

ID_NAME
    :  ID_START_CHAR ID_NAME_CHAR*
    ;

ID_QUALIFIED_NAME
    :  ID_NS '/' ID_NAME
    ;

fragment
ID_SYM_CHAR   // "other" chars excluding MACRO_CHARs and DISPATCH_MACRO_CHARs ???
    :  [!$#&*-_+=|:?/>.<]   // NB: '#' allowed inside ID:  (def a#b) => #'user/a#b
    ;

fragment
ID_START_CHAR
    :   [a-zA-Z]
    |   ID_SYM
    |   // covers all characters above 0xFF which are not a surrogate
        ~[\u0000-\u00FF\uD800-\uDBFF]
        {!Character.isDigit(_input.LA(-1))}?
    |   // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
        [\uD800-\uDBFF] [\uDC00-\uDFFF]
        {!Character.isDigit(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
        // {Character.isJavaIdentifierStart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
    ;

fragment
ID_NS_CHAR
    :  [a-zA-Zd]
    |  [\!#$%&*-_+=|\':?/>.<]   // '/' accepted
    |  // covers all characters above 0xFF which are not a surrogate
        ~[\u0000-\u00FF\uD800-\uDBFF]
        {Character.isJavaIdentifierPart(_input.LA(-1))}?
    |  // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
        [\uD800-\uDBFF] [\uDC00-\uDFFF]
        {Character.isJavaIdentifierPart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
    ;

fragment
ID_NAME_CHAR
    :  [a-zA-Zd]
    |  [\!#$%&*-_+=|\':?>.<]    // '/' rejected
    |  // covers all characters above 0xFF which are not a surrogate
        ~[\u0000-\u00FF\uD800-\uDBFF]
        {Character.isJavaIdentifierPart(_input.LA(-1))}?
    |  // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
        [\uD800-\uDBFF] [\uDC00-\uDFFF]
        {Character.isJavaIdentifierPart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
    ;

WS : [ \t\r\n\u000C\u2028]+ -> channel(WHITESPACE) ;

COMMENT : ';' ~[\r\n]*  -> channel(COMMENTS) ;

// fragment
// ID_LETTER
//     :   [a-zA-Z$_] // these are the "java letters" below 0xFF
//     |   // covers all characters above 0xFF which are not a surrogate
//         ~[\u0000-\u00FF\uD800-\uDBFF]
//         {!Character.isDigit(_input.LA(-1))}?
//         // {Character.isJavaIdentifierStart(_input.LA(-1))}?
//     |   // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
//         [\uD800-\uDBFF] [\uDC00-\uDFFF]
//         {Character.isJavaIdentifierStart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
//     ;

// fragment
// ID_LETTER_DIGIT
//     :   [a-zA-Z0-9\$\_] // these are the "java letters or digits" below 0xFF
//     |   // covers all characters above 0xFF which are not a surrogate
//         ~[\u0000-\u00FF\uD800-\uDBFF]
//         {Character.isJavaIdentifierPart(_input.LA(-1))}?
//     |   // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
//         [\uD800-\uDBFF] [\uDC00-\uDFFF]
//         {Character.isJavaIdentifierPart(Character.toCodePoint((char)_input.LA(-2), (char)_input.LA(-1)))}?
//     ;

// NAME  : (('/' | ~[0-9])~[/]*) ;

// a Clojure keyword = ns/name, algebraically (namespace :a/b) = :a, (name :a/b) = b

// once the regex is matched, the code in matchSymbol enforces further constraints
//
// private static Object matchSymbol(String s){
//     Matcher m = symbolPat.matcher(s);
//     if(m.matches())
// 	{
// 	    int gc = m.groupCount();
// 	    String ns = m.group(1);
// 	    String name = m.group(2);
// 	    if(ns != null && ns.endsWith(":/")
// 	       || name.endsWith(":")
// 	       || s.indexOf("::", 1) != -1)
// 		return null;
/// NS constraint: ns may not:
///    a) end with ':/'
///    b) end with ':'
///    c) contain '::' EXCEPT as first two chars

// 	    if(s.startsWith("::"))
// 		{
// 		    Symbol ks = Symbol.intern(s.substring(2));
// 		    Namespace kns;
// 		    if(ks.ns != null)
// 			kns = Compiler.namespaceFor(ks);
// 		    else
// 			kns = Compiler.currentNS();
// 		    //auto-resolving keyword
// 		    if (kns != null)
// 			return Keyword.intern(kns.name.name,ks.name);
// 		    else
// 			return null;
// 		}
// 	    boolean isKeyword = s.charAt(0) == ':';
// 	    Symbol sym = Symbol.intern(s.substring(isKeyword ? 1 : 0));
// 	    if(isKeyword)
// 		return Keyword.intern(sym);
// 	    return sym;
// 	}
//     return null;
// }

// SYM : :?([\\D&&[^/]].*/)?(/|[\\D&&[^/]][^/]*) ;

// // SYMBOL: '.' | '/' | NAME ('/' NAME)? ;

// SYMBOL: '.' | '/' | NAME ('.' SYMBOL_REST*)? ('/' SYMBOL_REST*)? ;

// // fragment
// NAME: SYMBOL_HEAD SYMBOL_REST* (':' SYMBOL_REST+)* ;

// // fragment
// SYMBOL_HEAD
//     :   'a'..'z' | 'A'..'Z' | '*' | '+' | '!' | '-' | '_' | '?' | '>' | '<' | '=' | '$'
//     ;

// // fragment
// SYMBOL_REST
//     : SYMBOL_HEAD
//     | '&' // apparently this is legal in an ID: "(defn- assoc-&-binding ..." TJP
//     | '0'..'9'
//     | '.'
//     ;


