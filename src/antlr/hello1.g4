grammar hello1;
start : HI ID ;

HI : 'hello' ;
ID : [a-zA-Z]+ ;
WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines, \r (Windows)


