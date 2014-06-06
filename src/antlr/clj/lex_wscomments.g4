lexer grammar wscomments ;

// CAVEAT: this lexer grammar will produce ignorable warnings:

// warning(155): nil.g4:20:26: rule 'WS' contains a lexer command with an unrecognized constant value; lexer interpreters may produce incorrect output
// warning(155): nil.g4:34:34: rule 'COMMENT' contains a lexer command with an unrecognized constant value; lexer interpreters may produce incorrect output

@lexer::members {
public static final int WHITESPACE = 1;
public static final int COMMENTS = 2;
}

COMMENT : ';' .*? '\n' -> channel(COMMENTS) ;

WS : [ \t\n\r\u2028] -> channel(WHITESPACE) ;
