# ANTLR 4 Lexing

See [org.antlr.v4.runtime.Lexer](http://www.antlr.org/api/Java-master/org/antlr/v4/runtime/Lexer.html)

## Lexical Grammars

An ANTLR lexical scanner just scans the input string and tries to
recognize tokens along the way.  It does not recognize syntactic
structures, so there is no *start* rule.

ANTLR supports mixing of lexical and syntactical grammars in a single
file; such *combined* grammars begin with:

```
grammar Foo ;   // foo (lower-case) works too
```

But you can also keep them separate.  A lexical grammar starts with:

```
lexer grammar Foo ;  // foo also works
```

In ANTLR's meta-syntax, lexical rules must begin with an uppercase
letter:

```
DIGIT : [0-9] ;    // Digit also works
```

You can combine:

```
FOO :  BAR BAZ ;
```

If you want to use some tokens for readability but not send them to
the parser, use `fragment`:

```
fragment BAR : 'bar' ;
fragment BAZ : 'baz' ;
```

Then "barbaz" will be recognized as a `FOO` token.

## Making it Work

Once you've written a lexical grammar and generated the Java source
files for it, you need to hook it up with some other machinery to make
it useful.  In particular, you have to provide a source of characters
**to** it for scanning/recognizing, and you need a way to pull
recognized tokens **from** it.

Structure:

from DA4R:

```java
 // create a CharStream that reads from standard input
ANTLRInputStream input = new ANTLRInputStream(System.in);
// create a lexer that feeds off of input CharStream
ArrayInitLexer lexer = new ArrayInitLexer(input);
// alternatively: create the lexer with ArrayInitLexer()
// then attach the input stream using `setInputStream`
// create a buffer of tokens pulled from the lexer
CommonTokenStream tokens = new CommonTokenStream(lexer);
```

You can see the Clojure equivalent of this in [../src/clojure/org/mobileink/antlr/lex.clj](../src/clojure/org/mobileink/antlr/lex.clj).

If we were also using a parser, then we would attach this token stream
object to the parser, which would use it to pull tokens from the
lexer.  But to test a standalone lexer, we can invoke the `fill`
method on the token stream: `tokens.fill()`, after which we can obtain
the list of tokens: `tokens.getTokens()`, and we can then iterate over
them.

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



.
