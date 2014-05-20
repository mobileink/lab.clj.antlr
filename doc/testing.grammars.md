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

