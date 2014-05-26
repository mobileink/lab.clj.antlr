# Lexing with ANTLR 4 and Clojure

Structure:

from DA4R:

```java
 // create a CharStream that reads from standard input
ANTLRInputStream input = new ANTLRInputStream(System.in);
// create a lexer that feeds off of input CharStream
ArrayInitLexer lexer = new ArrayInitLexer(input);
// create a buffer of tokens pulled from the lexer
CommonTokenStream tokens = new CommonTokenStream(lexer);
```

Notes:

Once we have a
[lexer](http://www.antlr.org/api/Java-master/org/antlr/v4/runtime/Lexer.html),
we can pull tokens from it (e.g. using `getAllTokens`).  But the
tokens in the result will not have index information; the token dump
will look like:

```
[@-1,11:14='Dave',<2>,2:10]
```

where `@-1` means "this token was conjured up since it doesn't have a
valid index."  (Doc string from
[getTokenIndex](http://www.antlr.org/api/Java-master/org/antlr/v4/runtime/CommonToken.html#getTokenIndex%28%29),
which is a method of the `CommonToken` class.)

The way to get indices is to use a
[BufferedTokenStream](http://www.antlr.org/api/Java/org/antlr/v4/runtime/BufferedTokenStream.html)
if you don't need channels, or
[CommonTokenStream](http://www.antlr.org/api/Java/org/antlr/v4/runtime/CommonTokenStream.html)
if you do.  Then you can obtain the list of tokens by calling
[fill](http://www.antlr.org/api/Java/org/antlr/v4/runtime/BufferedTokenStream.html#fill%28%29),
which fills the stream with tokens from the lexer.
