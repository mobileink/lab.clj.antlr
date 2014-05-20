# dsl.antlr

Using [ANTLR 4](http://www.antlr.org/) from Clojure.

At the moment, this is just uses a leiningen project to organize ANTLR grammar development.

Next up: implementing ANTLR listeners and visitors in Clojure, so we can walk the tree in Clojure.

**WARNING** ANTRL 4 is substantially different from earlier versions,
and many of the examples you can find by searching the internet are
based on earlier versions.  Caveat lector.

## Usage

Not yet packaged and deployed as a jar; to experiment, clone the repo, then:

```
1.  $ ./clean.sh              ## clean out generated java parser source files in src/java/grammar
2.  $ ./antlr.sh Clojure.g4   ## generate java parser source files from src/grammar
3.  $ lein clean              ## clean out target
4.  $ lein javac              ## compile parser source to target/classes
```

Now test using antlr's testrig:

```
$ ./grun.sh org.mobileink.antlr.Clojure file -tokens
      (+ 1 2)
      ctrl-D
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

See section 1.2 "Executing ANTLR and Testing Recognizers" in [The Definitive ANTLR 4 Reference](http://pragprog.com/book/tpantlr2/the-definitive-antlr-4-reference).

**Caveat:** It's "antlr", not "antrl".  ;)

## See also

[An ANTLR grammar for Clojure](https://github.com/antlr/grammars-v4/tree/master/clojure)
is the basis of the  grammar we use here.

[Using Antlr from Clojure](http://www.nickpascucci.com/blog/2014/03/01/using-antlr-from-clojure/)
A blog post (March 2014) with a minimal example of how to parse Java files
using ANTLR 4 from Clojure, without the lein infrastructure we use.

[clj-antlr](https://github.com/aphyr/clj-antlr) is a more ambitious
effort to Clojurize ANTLR.  By contrast, the goal of this project is
limited to using Clojure to crawl the tree using standard ANTLR
methods.

