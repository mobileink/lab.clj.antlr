// the null language - comments and whitespace only

grammar nil;

import lex_wscomments ;

// @lexer::members {
// public static final int WHITESPACE = 1;
// public static final int COMMENTS = 2;
// }

start: ;

// WS : [ \t\n\r] -> channel(WHITESPACE) ;

// COMMENT : ';' .*? '\n' -> channel(COMMENTS) ;
