# dsl.antlr

Using [ANTLR 4](http://www.antlr.org/) from Clojure.

At the moment, this is just uses a leiningen project to organize ANTLR grammar development.

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

See [Testing](doc/testing.md) to see how to use ANTLR's built-in test rig.

**Caveat:** It's "antlr", not "antrl".  ;)

## Road map

* implement ANTLR listeners and visitors in Clojure, so we can walk the tree in Clojure.
* implement lein plugin
* implement lein template


## See also

[An ANTLR grammar for Clojure](https://github.com/antlr/grammars-v4/tree/master/clojure)
is the basis of the  grammar we use here.

[Getting Started with ANTRL v4](https://theantlrguy.atlassian.net/wiki/display/ANTLR4/Getting+Started+with+ANTLR+v4)
by Terrence Parr, the maniac behind ANTLR (his words, not mine!)

[Using Antlr from Clojure](http://www.nickpascucci.com/blog/2014/03/01/using-antlr-from-clojure/)
A blog post (March 2014) with a minimal example of how to parse Java files
using ANTLR 4 from Clojure, without the lein infrastructure we use.

[clj-antlr](https://github.com/aphyr/clj-antlr) is a more ambitious
effort to Clojurize ANTLR.  By contrast, the goal of this project is
limited to using Clojure to crawl the tree using standard ANTLR
methods.

