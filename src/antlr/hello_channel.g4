grammar hello_channel;
@lexer::members {
public static final int WHITESPACE = 3;
}

start : 'hello' ID ;
ID : [a-zA-Z]+ ;
WS : [ \t\r\n]+ -> channel(WHITESPACE) ; // send spaces, tabs, newlines, \r (Windows) to WHITESPACE channel


