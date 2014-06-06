/* Converted to ANTLR 4 by Terence Parr. Unsure of provence. I see
   it commited by matthias.koester for clojure-eclipse project on
   Oct 5, 2009:

   https://code.google.com/p/clojure-eclipse/

   Seems to me Laurent Petit had a version of this. I also see
   Jingguo Yao submitting a link to a now-dead github project on
   Jan 1, 2011.

   https://github.com/laurentpetit/ccw/tree/master/clojure-antlr-grammar

   Regardless, there are some issues perhaps related to "sugar";
   I've tried to fix them.

   This parses https://github.com/weavejester/compojure project.

   I also note this is hardly a grammar; more like "match a bunch of
   crap in parens" but I guess that is LISP for you ;)
 */

grammar Clojure;

file: ( form | defn_form | def_form | do_form | if_form | let_form)* ;

form: literal
    | list
    | vector
    | map
    | reader_macro
    | '#\'' SYMBOL // TJP added (get Var object instead of the value of a symbol)
    ;

defn_form: '(' DEFN  body ')';
def_form: '(' special_DEF SYMBOL body? ')';
do_form: '(' DO body ')';
if_form: '(' IF body ')';
let_form: '(' LET binding body ')';
loop_form: '(' LOOP body ')';
monitor_enter_form: '(' MONITOR_EN body ')';
monitor_exit_form: '(' MONITOR_EX body ')';
quote_form: '(' QUOTE body ')';
recur_form: '(' RECUR body ')';
throw_form: '(' THROW body ')';
try_form: '(' TRY body ')';
var_form: '(' VAR body ')';

head: special_DEF | DEFN | DO | LET | NAME ;

binding: '[' form* ']' ;

body: form+;

/* list: '(' form* ')' ; */
list: '(' form* ')' ;

// kw: 'defn' | 'def' | 'do' ; // etc.

vector: '[' form* ']' ;

map: '{' (form form)* '}' ;

// TJP added '&' (gather a variable number of arguments)
special_form: ('\'' | '`' | '~' | '~@' | '^' | '@' | '&') form ;

lambda: '#(' form* ')' ;

meta_data: '#^' map form ;

var_quote: '\'' '#' SYMBOL ;

regex: '#' STRING  ;

reader_macro
    : lambda
    | meta_data
    | special_form
    | regex
    | var_quote
    | SYMBOL '#' // TJP added (auto-gensym)
    ;

literal
    : STRING # str
    | NUMBER # nbr
    | CHARACTER #char
    | NIL #nil
    | BOOLEAN #bool
    | KEYWORD #keyw
    | SYMBOL #sym
    | PARAM_NAME #parm
    ;

STRING : '"' ( ~'"' | '\\' '"' )* '"' ;

NUMBER : '-'? [0-9]+ ('.' [0-9]+)? ([eE] '-'? [0-9]+)? ;

CHARACTER : '\\' . ;

NIL : 'nil';

BOOLEAN : 'true' | 'false' ;

KEYWORD : ':' SYMBOL_REST ; // :3a is legal

PARAM_NAME: '%' (('1'..'9')('0'..'9')*)? ;

DEFN  : 'defn' ;
special_DEF   : 'def' ;
DO    : 'do' ;
IF    : 'if' ;
LET   : 'let' ;
LOOP  : 'loop' ;
MONITOR_EN  : 'monitor-enter' ;
MONITOR_EX  : 'monitor-exit' ;
QUOTE : 'quote' ;
RECUR : 'recur' ;
THROW : 'throw' ;
TRY   : 'try' ;
VAR   : 'var' ;

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

// SYMBOL: '.' | '/' | NAME ('/' NAME)? ;

SYMBOL: '.' | '/' | NAME ('.' SYMBOL_REST*)? ('/' SYMBOL_REST*)? ;

// fragment
NAME: SYMBOL_HEAD SYMBOL_REST* (':' SYMBOL_REST+)* ;

// fragment
SYMBOL_HEAD
    :   'a'..'z' | 'A'..'Z' | '*' | '+' | '!' | '-' | '_' | '?' | '>' | '<' | '=' | '$'
    ;

// fragment
SYMBOL_REST
    : SYMBOL_HEAD
    | '&' // apparently this is legal in an ID: "(defn- assoc-&-binding ..." TJP
    | '0'..'9'
    | '.'
    ;

WS : [ \n\r\t\,] -> channel(HIDDEN) ;

COMMENT : ';' ~[\r\n]* -> channel(HIDDEN) ;
