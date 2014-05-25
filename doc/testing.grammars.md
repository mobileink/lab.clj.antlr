# Testing ANTLR Grammars

Once you've compiled a lexer/parser as shown in the
[README](../README.md), you can use ANTLR's
[TestRig](http://www.antlr.org/api/Java/org/antlr/v4/runtime/misc/TestRig.html)
to display various views of the parse tree.  The first argument to
TestRig is the name of a grammar (i.e. the name of the java package
implementing the parser); the second argument is the name of a rule to
be used to start parsing.  This means you can test parts of your
grammar independently.

To show resulting tokens:

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
Show the tree as nested syntax:
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

## TestRig -tokens Output

#### Whitespace discarded

Compile the hello1 grammar:

```
$ ./regen.sh hello1
```

Now take a look at the test file `test/hello.txt`, and note that the
input text is on line 2 of the file, and starts at the fourth character
position (counting from 0).  Run the test rig against this file:

```
$ ./grun.sh hello1 start hello.txt
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

Now compile hello2:

```
$ ./grun.sh hello1 start hello.txt
```

This time you should see a warning:

```
warning(155): hello2.g4:8:27: rule 'WS' contains a lexer command with an unrecognized constant value; lexer interpreters may produce incorrect output
```

Ignore this; it is caused by the use of a lexical "channel", which
this example is designed to illustrate.

Now run the test rig again:

```
$ ./grun.sh hello2 start hello.txt
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

The difference is that the hello1 grammar discards whitespace:

```
WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines, \r (Windows)
```

whereas hello2 retains it, passing it to the parser in a "channel":

```
@lexer::members {
public static final int WHITESPACE = 3;
}
...
WS : [ \t\r\n]+ -> channel(WHITESPACE) ; // send spaces, tabs, newlines, \r (Windows) to WHITESPACE channel
```

The `channel=3` clauses in the test rig output indicates which strings
are recognized by the WS rule and passed on channel 3.



.
