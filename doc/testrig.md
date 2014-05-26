# Testing with the ANTLR 4 TestRig

Once you've compiled a lexer/parser as shown in the
[README](../README.md), you can use ANTLR's
[TestRig](http://www.antlr.org/api/Java/org/antlr/v4/runtime/misc/TestRig.html)
to display various views of the parse tree.  The first argument to
TestRig is the name of a grammar (i.e. the name of the java package
implementing the parser); the second argument is the name of a rule to
be used to start parsing.  This means you can test parts of your
grammar independently.  The optional third parameter is a filename; if
you provide it, TestRig will feed its contents to the parser.  If you
omit it (as in the following examples), you can enter text to be
parsed on the command line, terminated with a CTRL-D.

> See [Testing ANTLR 4 Lexers/Parsers with Clojure](testing.clojure.md) to see how to test
> from a repl or by running `lein test`.

To show resulting tokens use the `-tokens` flag:

```
$ ./grun.sh org.mobileink.antlr.Clojure file -tokens
      (+ 1 2)
      ^D  ## = ctrl-D
(+ 1 2)
[@0,0:0='(',<9>,1:0]
[@1,1:1='+',<28>,1:1]
[@2,2:2=' ',<30>,channel=1,1:2]
[@3,3:3='1',<23>,1:3]
[@4,4:4=' ',<30>,channel=1,1:4]
[@5,5:5='2',<23>,1:5]
[@6,6:6=')',<5>,1:6]
[@7,7:7='\n',<30>,channel=1,1:7]
[@8,8:7='<EOF>',<-1>,2:8]
$
```

Show the tree as nested syntax use `-tree`:

```
$ ./grun.sh org.mobileink.antlr.Clojure file -tree
(do (+ 1 2))
^D
(file (form (list ( (form (kw do)) (form (list ( (form (literal +)) (form (literal 1)) (form (literal 2)) ))) ))))
$
```

The -gui option displays the the parse tree graphically in a gui window:

```
./grun.sh org.mobileink.antlr.Clojure file -gui
(do (+ 1 2))
^D
...gui launches...
```

Write to ps (!) file:

```
./grun.sh org.mobileink.antlr.Clojure file -ps target/expr.ps
(do (+ 1 2))
^D
...write parse tree graphic to expr.ps...
```

See sections 1.2 "Executing ANTLR and Testing Recognizers" and 3.2
"Testing the Generated Parser" in
[The Definitive ANTLR 4 Reference](http://pragprog.com/book/tpantlr2/the-definitive-antlr-4-reference).

## Interpretation of TestRig -tokens Output

#### Whitespace discarded

From the project root, compile the [hello](../src/antlr/hello.g4) grammar:

```
$ ./regen.sh hello
```

Now take a look at the test file [test/data/hello.txt](../test/data/hello.txt),
and note that the input text is on line 2 of the file, and starts at
the fourth character position (counting from 0).  Run the test rig
against this file:

```
$ ./grun.sh hello start hello.txt
```

The result should look like this:

```
[@0,5:9='hello',<1>,2:4]
[@1,11:14='Dave',<2>,2:10]
[@2,16:15='<EOF>',<-1>,3:0]
```

Abstractly:  [@<token nbr>,<abs position>='<recognized string>',<rule nbr>,<row-col position>]

Line one of this output:

* `@0` indicates this is the first token recognized (counting starts at 0)
* `5:9='hello'` means that:
  * the recognized string is 'hello'
  * it starts at absolute file position 5 (counting from 0) and ends at 9
* `<1>' means the token was recognized by rule 1, making it a type 1 token
* `2:4` following `<1>,` means the recognized string is on row 2, col 4 (counts start at 0)

#### Whitespace retained

Now compile [hello_channels](../src/antlr/hello_channels.g4):

```
$ ./regen sh hello_channels
```

This time you should see a warning:

```
warning(155): hello_channels.g4:8:27: rule 'WS' contains a lexer command with an unrecognized constant value; lexer interpreters may produce incorrect output
```

Ignore this; it is caused by the use of a lexical "channel", which
this example is designed to illustrate.

> Channels allow the lexer to pass selected tokens to the parser as
"hidden" streams of tokens; this allows you to retain e.g. whitespace
and comments.  They get passed on separate channels, which means the
parser can ignore them and stick to the business of parsing the
meaningful tokens; but it has the option of fetching tokens from the
hidden channels.  See section 12.1, "Broadcasting Tokens on Different
Channels", p. 204 of DA4R.

Now test the parser:

```
$ ./grun.sh hello_channels start "hello.txt"
```

This time the output should look like this:

```
[@0,0:4='\n    ',<3>,channel=3,1:0]
[@1,5:9='hello',<1>,2:4]
[@2,10:10=' ',<3>,channel=3,2:9]
[@3,11:14='Dave',<2>,2:10]
[@4,15:15='\n',<3>,channel=3,2:14]
[@5,16:15='<EOF>',<-1>,3:15]
```

The difference is that the hello grammar discards whitespace:

```
WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines, \r (Windows)
```

whereas hello_channels retains it, passing it to the parser in a "channel":

```
@lexer::members {
public static final int WHITESPACE = 3;
}
...
WS : [ \t\r\n]+ -> channel(WHITESPACE) ; // send spaces, tabs, newlines, \r (Windows) to WHITESPACE channel
```

The `channel=3` clauses in the test rig output indicates which strings
are recognized by the WS rule and passed from lexer on channel 3.



.
