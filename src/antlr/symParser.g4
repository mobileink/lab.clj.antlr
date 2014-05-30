parser grammar symParser;

tokens {LETTER}
options { tokenVocab=symLexer; }

// start : id_symbol+ EOF ;
start : def EOF ; //list+ EOF ;

list : LPAREN id_symbol (WS+ id_symbol)* RPAREN ;

def  : LPAREN DEF id_symbol id_symbol* RPAREN ;

// [:]?([\\D&&[^/]].*/)?(/|[\\D&&[^/]][^/]*)

id_symbol : (id_ns SLASH)? id_nm ;

pfx   : id_ns SLASH ;
id_ns : ID_NS ;
id_nm : (SLASH | ID_NS) ;

word : LETTER+ ;
