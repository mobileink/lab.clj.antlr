grammar hello;
start : 'hello' ID ;
ID : [a-zA-Z]+ ;
WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines, \r (Windows)


