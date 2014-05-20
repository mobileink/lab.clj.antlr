# dsl.antlr

Using antlr from Clojure


## Usage

```
1.  $ ./clean.sh              ## clean out generated java parser source files in src/java/grammar
2.  $ ./antlr.sh Clojure.g4   ## generate java parser source files from src/grammar
3.  $ lein clean
4.  $ lein javac              ## compile parser source to target/classes
```

Now test using antlr's testrig:

```
$ ./grun.sh org.mobileink.antlr.Clojure file -tokens
      (+ 1 2)
      ctrl-D
```

See section 1.2 "Executing ANTLR and Testing Recognizers" in [The Definitive ANTLR 4 Reference](http://pragprog.com/book/tpantlr2/the-definitive-antlr-4-reference).

**Caveat:** It's "antlr", not "antrl".  ;)
