lexer grammar lex_clj ;

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

