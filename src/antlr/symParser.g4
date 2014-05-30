parser grammar symParser;

options { tokenVocab=symLexer; }

start : id_symbol+ EOF ;
// start : def EOF ; //list+ EOF ;

list : LPAREN id_symbol id_symbol* RPAREN ;

def  : LPAREN DEF id_symbol (WS id_symbol)* RPAREN ;

// [:]?([\\D&&[^/]].*/)?(/|[\\D&&[^/]][^/]*)
id_symbol : (id_ns DIV)? id_nm ;

id_ns : ID_NS ;
id_nm : (DIV {(char)_input.LA(1)==' '}? | ID_NS) ;

