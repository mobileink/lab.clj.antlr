parser grammar symParser;

options { tokenVocab=symLexer; }
//tokens {DIGIT}

start : list+ EOF;
// start : def EOF ; //list+ EOF ;

// TODO: embedded lists
list : LPAREN expr (expr | numeral)* RPAREN ;

def  : LPAREN DEF id_symbol (WS id_symbol)* RPAREN ;

expr : list | id_special | id_predef | id_op | id_symbol ;

// [:]?([\\D&&[^/]].*/)?(/|[\\D&&[^/]][^/]*)
id_symbol : (id_ns SLASH)? id_nm ;

id_special : SPECIAL ;
id_predef  : PREDEF  ;
id_op      : OP ;

id_ns : ID_NS ;
id_nm : (DIV | ID_NS) ;

numeral : NUMERAL ;

//id_nm : (DIV {stops.contains(Character.toString((char)_input.LA(1)))}? | ID_NS) ;


