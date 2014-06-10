lexer grammar identifiers ;

// @lexer::members { // add members to generated symParser
// public static final int WHITESPACE = 3;
// public static final int COMMENTS = 5;
// public static final String stops = " \t\n";
// }

// import ws ;

// standard namespaces
NS_CLJ_CORE : 'clojure.core' ;
NS_CLJ_LANG : 'clojure.lang' ;
// ...etc...

// specials

//SPECIAL :  DEF | DEFN | OR ;
DEF : 'def' ;
IF : 'if' ;
DO : 'do' ;
LET : 'let' ;
QUOTE : 'quote' ;
VAR : 'var' ;
FN : 'fn' ;
LOOP : 'loop' ;
RECUR : 'recur' ;
EXCP : 'throw' | 'try' | 'catch' | 'finally' ;
// THROW : 'throw' ;
// TRY : 'try' ;
// CATCH : 'catch' ;
// FINALLY : 'finally' ;
MONITOR_ENTER : 'monitor-enter' ;
MONITOR_EXIT  : 'monitor-exit' ;
NEW : 'new' ;
SETBANG : 'setbang' ;

//macros http://clojure.org/macros
DEFMACRO : 'defmacro' ;
DEFINLINE : 'definline' ;
MACROEXPAND_1 : 'macroexpand-1' ;
MACROEXPAND : 'macroexpand' ;
AND : 'and' ;
OR : 'or' ;
WHEN : 'when' ;
WHEN_NOT : 'when-not' ;
WHEN_LET : 'when-let' ;
WHEN_FIRST : 'when-first' ;
IF_NOT : 'if-not' ;
IF_LET : 'if-let' ;
COND : 'cond' ;
CONDP : 'condp' ;
FOR : 'for' ;
DOSEQ : 'doseq' ;
DOTIMES : 'dotimes' ;
WHILE : 'while' ;
NS : 'ns' ;
DECLARE : 'declare' ;
DEFN : 'defn' ;
DEFN_ : 'defn-' ;
DEFMETHOD : 'defmethod' ;
DEFMULTI : 'defmulti' ;
DEFONCE : 'defonce' ;
DEFSTRUCT : 'defstruct' ;
DOTO : 'doto' ;
THREAD : 'thread' ;
JAVA_THREAD    :  '..' ;
BINDING : 'binding' ;
LOCKING : 'locking' ;
TIME : 'time' ;
WITH_IN_STR : 'with-in-str' ;
WITH_LOCAL_VARS : 'with-local-vars' ;
WITH_OPEN : 'with-open' ;
WITH_OUT_STR : 'with-out-str' ;
WITH_PRECISION : 'with-precision' ;
LAZY_CAT : 'lazy-cat' ;
LAZY_CONS : 'lazy-cons' ;
DELAY : 'delay' ;
AMAP : 'amap' ;
AREDUCE : 'areduce' ;
GEN_CLASS : 'gen-class' ;
GEN_INTERFACE : 'gen-interface' ;
PROXY : 'proxy' ;
PROXY_SUPER : 'proxy-super' ;
MEMFN : 'memfn' ;
ASSERT : 'assert' ;
COMMENT : 'comment' ;
DOC : 'doc' ;
DOSYNC : 'dosync' ;
IOBANG : 'iobang' ;

////////////////////////////////////////////////////////////////
//Other funcs  http://clojure.org/other_functions

// boolean and comparison
EQ : '=' {stops.contains(Character.toString((char)_input.LA(1)))}? ;
IDENTICALP : 'identicalp' ;
NOTEQ : 'noteq' ;
NOT : 'not' ;
TRUEP : 'truep' ;
FALSEP : 'falsep' ;
NILP : 'nilp' ;

//misc
IDENTITY : 'identity' ;

// creating funcs
PARTIAL : 'partial' ;
COMP : 'comp' ;
COMPLEMENT : 'complement' ;
CONSTANTLY : 'constantly' ;

//printing
//http://clojure.org/other_functions#Other%20Useful%20Functions%20and%20Macros-Printing
PRINTLN : 'println' ;
PRINT : 'print' ;
PRN : 'prn' ;
PR : 'pr' ;
NEWLINE : 'newline' ;
PR_STR : 'pr-str' ;
PRN_STR : 'prn-str' ;
PRINT_STR : 'print-str' ;
PRINTLN_STR : 'println-str' ;
//WITH_OUT_STR : 'with-out-str' ;

//regex
//http://clojure.org/other_functions#Other%20Useful%20Functions%20and%20Macros-Regex%20Support
RE_FIND : 're-find' ;
RE_GROUPS : 're-groups' ;
RE_MATCHER : 're-matcher' ;
RE_MATCHES : 're-matches' ;
RE_PATTERN : 're-pattern' ;
RE_SEQ : 're-seq' ;

//number
//http://clojure.org/data_structures#Data%20Structures-Numbers-Related%20functions
// computation
INC : 'inc' ;
DEC : 'dec' ;
QUOT : 'quot' ;
REM : 'rem' ;
MIN : 'min' ;
MAX : 'max' ;
// auto-promoting computation
ADD_TICK : 'add-tick' ;
SUB_TICK : 'sub-tick' ;
MUL_TICK : 'mul-tick' ;
INC_TICK : 'inc-tick' ;
DEC_TICK : 'dec-tick' ;
// comparison
EQEQ : 'eqeq' ;
LT : 'lt' ;
LEQ : 'leq' ;
GT : 'gt' ;
GEQ : 'geq' ;
ZEROP : 'zerop' ;
POSP : 'posp' ;
NEGP : 'negp' ;
// bitwise
BIT_AND : 'bit-and' ;
BIT_OR : 'bit-or' ;
BIT_XOR : 'bit-xor' ;
BIT_NOT : 'bit-not' ;
BIT_SHIFT_R : 'bit-shift-r' ;
BIT_SHIFT_L : 'bit-shift-l' ;
// ratios
NUMERATOR : 'numerator' ;
DENOMINATOR : 'denominator' ;
// coercions
INT : 'int' ;
BIGDEC : 'bigdec' ;
BIGINT : 'bigint' ;
DOUBLE : 'double' ;
FLOAT : 'float' ;
LONG : 'long' ;
NUM : 'num' ;
SHORT : 'short' ;
// strings - see also printing, above
STR : 'str' ;
STRINGP : 'stringp' ;
// characters
CHAR : 'char' ;
CHAR_NAME_STRING : 'char-name-string' ;
CHAR_ESCAPE_STRING : 'char-escape-string' ;
// keywords
KEYWORD : 'keyword' ;
KEYWORDP : 'keywordp' ;
// symbols
SYMBOLP : 'symbolp' ;
SYMBOL : 'symbol' ;
GENSYM : 'gensym' ;

// collections
COUNT : 'count' ;

// kernel/prelude functions
//PREDEF :  LIST | MAP | CONJ ;
UNQUOTE : 'unquote' ;
UNQUOTE_SPLICING : 'unquote-splicing' ;
LIST   :  'list' ;
CONJ   :  'conj' ;
FFIRST : 'ffirst' ;
NFIRST : 'nfirst' ;
SECOND : 'second' ;

// sequence lib http://clojure.org/sequences#Sequences-The%20Seq%20interface
SEQ : 'seq' ;
FIRST : 'first' ;
REST : 'rest' ;
// seq in, seq out
DISTINCT : 'distinct' ;
FILTER : 'filter' ;
REMOVE : 'remove' ;
//FOR : 'for' ;
KEEP : 'keep' ;
KEEP_INDEXED : 'keep-indexed' ;
CONS : 'cons' ;
CONCAT : 'concat' ;
//LAZY_CAT : 'lazy-cat' ;
MAPCAT : 'mapcat' ;
CYCLE : 'cycle' ;
INTERLEAVE : 'interleave' ;
INTERPOSE : 'interpose' ;
NEXT : 'next' ;
FNEXT : 'fnext' ;
NNEXT : 'nnext' ;
NTHNEXT : 'nthnext' ;
DROP : 'drop' ;
DROP_WHILE : 'drop-while' ;
//FOR : 'for' ;
TAKE : 'take' ;
TAKE_NTH : 'take-nth' ;
TAKE_WHILE : 'take-while' ;
BUTLAST : 'butlast' ;
DROP_LAST : 'drop-last' ;
//FOR
FLATTEN : 'flatten' ;
REVERSE : 'reverse' ;
SORT : 'sort' ;
SORT_BY : 'sort-by' ;
SHUFFLE : 'shuffle' ;
SPLIT_AT : 'split-at' ;
SPLIT_WITH : 'split-with' ;
PARTITION : 'partition' ;
PARTITION_ALL : 'partition-all' ;
PARTITION_BY : 'partition-by' ;
MAP : 'map' ;
PMAP : 'pmap' ;
//MAPCAT
//FOR
REPLACE : 'replace' ;
REDUCTIONS : 'reductions' ;
MAP_INDEXED : 'map-indexed' ;
SEQUE : 'seque' ;

OP     :  ADD | SUB | MUL | DIV | EQ ;

ADD    :  '+' {stops.contains(Character.toString((char)_input.LA(1)))}? ;
SUB    :  '-' {stops.contains(Character.toString((char)_input.LA(1)))}? ;
MUL    :  '*' {stops.contains(Character.toString((char)_input.LA(1)))}? ;
DIV    :  '/' {stops.contains(Character.toString((char)_input.LA(1)))}? ;

// trailing {...}? is an antlr 4 "semantic predicate"; it must be true
// for the match to work.  in this case, the predicate means that
// these ops must be followed by whitespace if they are not part of a
// symbol; otherwise, something like (+1 2) would be parsed as (+ 1 2)
// but +1 is a valid clojure (symbol) name part try this:
// (def user/-1/ 0)
// (+ user/-1 1) => 1


