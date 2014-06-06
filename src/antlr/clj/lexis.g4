lexer grammar lexis ;

@lexer::members {
public static final int WHITESPACE = 3;
public static final int COMMENTS = 5;
public static final String stops = " \t\n";
}

import literals, symbols, identifiers ;

// antlr's import doesn't seem to work if text refers to @lexer
// members stuff so we must include ws and comments directly:

WS  :  [ \t\r\n\u000C]+ -> channel(WHITESPACE)
    ;

LINE_COMMENT
    :   ';' ~[\r\n]* -> channel(COMMENTS)
    ;
