/*
 [The "BSD licence"]
 Copyright (c) 2014 Terence Parr, Sam Harwell
 Modified (c) 2014 Gregg Reynolds
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 3. The name of the author may not be used to endorse or promote products
    derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
clojure literal syntax.  based on Java8 grammar
 */

// clojure.lang.LispReader.java intPat regex:
// ([-+]?)(?:(0)|([1-9][0-9]*)|0[xX]([0-9A-Fa-f]+)|0([0-7]+)|([1-9][0-9]?)[rR]([0-9A-Za-z]+)|0[0-9]+)(N)?

// the grammar here is based on the Java grammar in the antlr repo,
// which is based on the language defn:
// Java §3.10.1 Integer Literals
// http://docs.oracle.com/javase/specs/jls/se7/html/jls-3.html#jls-3.10.1

// DIFFERENCES:
// Java allows underscores in numeric lits, e.g. 0xFF_FF, 0b0111_0111
// Clojure does not.

// Java supports binary syntax:  0b01010
// Clojure does not; instead us radix notation: 2r01010

// Longs: Java supports type suffixes: 99L, 0xFFl, etc.
// Clojure does not; it figures out the right representation

// BigInt is Clojure-specific:  123N
// BigDecimal is Clojure-specific:  123M

// Floating point: Clojure disallows the [fF] suffix; it reads floats
// as doubles or BigDecimal with M suffix:
// user=> (class 2.5)
// java.lang.Double
// user=> (class 2.5M)
// java.math.BigDecimal
// Java allows floats to start with '.', e.g.  .2
// Clojure disallows this

// Hex floating point, e.g. 0x1.8p1: disallowed

// WARNING:  0123 is octal notation
// 0123 = 83 dec; 0123N = 83 dec; but 0123M = 123 dec

// see radix.g4 for radix notation e.g. 16rFF = 0xFF

// WARTS: The official Java (1.7) grammar treats e.g. -1, +1 as
// expressions - syntactic phrases combining '-' or '+' with a numeral
// literal.  We don't think that makes sense, harrumph.  After all,
// so-called 'literals' like '123' or '0xFF' are also expressions.  So we
// treat the unary -/+ syms as part of the literal.



lexer grammar literals ;

import radix ;

// Numeral
//     :   ('+' | '-')? IntegerNumeral
//     |   ('+' | '-')? FloatingPointNumeral
//     ;

// Literal
//     :   CharacterLiteral
//     |   StringLiteral
//     |   BooleanLiteral
//     |   NilLiteral
//     ;

// IntegerNumeral
//     :   DecimalNumeral
//     |   HexNumeral
//     |   OctalNumeral
//     |   RadixNumeral     // defined in radix.g4
//     ;

// IntegerLiteral
//     :   DecimalIntegerLiteral
//     |   HexIntegerLiteral
//     |   OctalNumeral
//     |   RadixIntegerLiteral     // defined in radix.g4
//     ;

//fragment
DecimalNumeral
    : ('+' | '-')? [02-9]
    | ('+' | '-')? NonZeroDigit Digits?
    ;

BadDecimal : ('+' | '-')? [1-9] ~[xXrR \t\r\n]+ ;

// fragment
// DecimalIntegerLiteral
//     :   DecimalNumeral
//     ;

//fragment
HexNumeral :  ('+' | '-')? '0' [xX] HexDigits ;

BadHex :  ('+' | '-')? '0' [xX] ~[ \t\r\n]+ ;

// fragment
// HexIntegerLiteral
//     :   HexNumeral
//     ;

// fragment
// DecimalNumeral
//     :   '0'
//     |   NonZeroDigit Digits
//     ;

fragment
Digits
    :   '0'
    |   NonZeroDigit
    ;

// DIGIT - see alphabet.g4

// fragment
// HexNumeral
//     :   '0' [xX] HexDigits
//     ;

fragment
HexDigits
    :   HexDigit+
    ;

fragment
HexDigit
    :   [0-9a-fA-F]
    ;

//fragment
OctalNumeral :  ('+' | '-')? '0' OctalDigit+ ;

BadOctal :  ('+' | '-')? '0' ~[ \t\r\n]+ ;

fragment
OctalDigit : [0-7] ;

// §3.10.2 Floating-Point Literals

FloatingPointNumeral : ('+' | '-')? DecimalFloatingPointLiteral ;

fragment
DecimalFloatingPointLiteral
    :   Digits '.' Digits? ExponentPart?
    // |   '.' Digits ExponentPart?
    |   Digits ExponentPart
    ;

fragment
ExponentPart
    :   ExponentIndicator SignedInteger
    ;

fragment
ExponentIndicator
    :   [eE]
    ;

fragment
SignedInteger
    :   Sign? Digits
    ;

fragment
Sign
    :   [+-]
    ;

// §3.10.3 Boolean Literals

BooleanLiteral
    :   'true'
    |   'false'
    ;

// §3.10.4 Character Literals

CharacterLiteral
    :   '\\' SingleCharacter
    |   EscapeSequence
    ;

fragment
SingleCharacter
    :   ~['\\]
    ;

// §3.10.5 String Literals

StringLiteral
    :   '"' StringCharacters? '"'
    ;

fragment
StringCharacters
    :   StringCharacter+
    ;

fragment
StringCharacter
    :   ~["\\]
    |   EscapeSequence
    ;

// §3.10.6 Escape Sequences for Character and String Literals

fragment
EscapeSequence
    :   '\\' 'space'
    |   '\\' 'backspace'
    |   '\\' 'tab'
    |   '\\' 'return'
    |   '\\' 'newline'
    |   '\\' 'formfeed'
    |   '\\' '|"'
    |   '\\' '\''
    |   CharEscape
    |   OctalEscape
    |   UnicodeEscape
    ;

fragment
CharEscape
    :   '\\' LETTER
    ;

fragment
OctalEscape
    :   '\\' 'o' OctalDigit
    |   '\\' 'o' OctalDigit OctalDigit
    |   '\\' 'o' ZeroToThree OctalDigit OctalDigit
    ;

fragment
UnicodeEscape
    :   '\\' 'u' HexDigit HexDigit HexDigit HexDigit
    ;

fragment
ZeroToThree
    :   [0-3]
    ;

NilLiteral
    :   'nil'
    ;

// //
// // Whitespace and comments
// //

// WS  :  [ \t\r\n\u000C]+ -> skip
//     ;

// LINE_COMMENT
//     :   ';' ~[\r\n]* -> skip
//     ;
