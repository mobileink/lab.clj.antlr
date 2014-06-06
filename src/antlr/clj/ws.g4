lexer grammar ws;
//
// Whitespace and comments
//

// if you import this into another lexer or parser
// include these mbr defns:
// @lexer::members {
// public static final int WHITESPACE = 3;
// public static final int COMMENTS = 5;
// }

WS  :  [ \t\r\n\u000C]+ -> channel(WHITESPACE)
    ;

LINE_COMMENT
    :   ';' ~[\r\n]* -> channel(COMMENTS)
    ;
