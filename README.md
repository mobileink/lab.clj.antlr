# rsch.antlr

This project is intended as a kind of research workbench for exploring
[ANTLR 4](http://www.antlr.org/) with [Clojure](http://clojure.org/).
It will never be published as a product, so it does not have an
alpha-beta-production status.  What's included here is enough (I hope)
machinery and documentation to get you started working with ANTLR
grammars right away, without having to worry about the
[boring details of running the ANTLR tools, organizing your code, etc](https://theantlrguy.atlassian.net/wiki/display/ANTLR4/Getting+Started+with+ANTLR+v4)
).  What's here seems to work, so if you want to use it, just clone it
and hammer away.

The original motivation was to develop a formal grammar for Clojure,
so some of the examples are specific to that language.  But the tools
and documentation here are language-agnostic; ANTLR 4 can be used to
develop any grammar, and you can use the tools here to experiment with
any grammar.

See the
[ANTLR Grammar Repository](https://github.com/antlr/grammars-v4) for
many examples, including a
[rudimentary Clojure grammar](https://github.com/antlr/grammars-v4/tree/master/clojure).

**WARNING** ANTRL 4 is substantially different from earlier versions,
and many of the examples you can find by searching the internet are
based on earlier versions.  Caveat lector.

See the docs in [doc](doc/) for more information.  If you're going to
do serious grammar development, get a copy of
[The Definitive ANTLR 4 Reference](http://pragprog.com/book/tpantlr2/the-definitive-antlr-4-reference).

## Organization

This project exploits leiningen's conventions:

* Grammar files go in `src/antlr`
* Generated java implementation code goes in `src/java`
* Compiled parser classes go in `target`
* Test data is in `test/data`
* Clojure source (a few testing tools) is in `src/clojure`
* Clojure test files are in `test` exclusive of `test/data`

Shell scripts in the project root directory:

* antlr4.sh - run [org.antlr.v4.Tool](https://theantlrguy.atlassian.net/wiki/display/ANTLR4/ANTLR+Tool+Command+Line+Options) to generate Java implemention files
* clean.sh - remove generated Java implementation files from `src/java`
* regen.sh - runs clean.sh, then antlr4.sh, then lein javac
* grun.sh - runs [org.antlr.v4.runtime.misc.TestRig](http://www.antlr.org/api/Java/org/antlr/v4/runtime/misc/TestRig.html)

## Usage

To get started, clone the repo and then from the project root run:

```
1.  $ ./antlr4.sh hello.g4     ## generate java parser source files from src/grammar/Clojure.g4
2.  $ lein javac              ## compile parser source to target/classes
```

> **Caveat:** It's "antlr", not "antrl".  ;)

This generates the lexer and parser Java code from the ANTLR grammar
([src/antlr/hello.g4](src/antlr/hello.g4)), then compiles it.  Use
[regen.sh](regen.sh) as you work on your grammar; it combines clean, gen,
compile steps.

> The Clojurish Thing To Do is to write a leiningen plugin to run
> ANTLR, so we can do `$ lein antlr hello`, but I haven't gotten
> around to it yet.

## Testing

To test the parser, you have two options.  The ANTLR way:

```
$ ./grun.sh hello start "hello.txt" ## run ANTLR TestRig against parser and test file
```

`grun.sh` runs ANTLR's
[TestRig](http://www.antlr.org/api/Java/org/antlr/v4/runtime/misc/TestRig.html);
see [ANTLR 4 TestRig](doc/testrig.md) for further information.

The Clojure way(s):

```
$ lein test hello
```

Another Clojure way is to run the parser from a repl; see
[Testing ANTLR 4 Lexers/Parsers with Clojure](doc/testing.clojure.md)
for details.

## Lexing

See [ANTLR 4 Lexing](doc/lexing.md).

## Parsing

See [ANTLR 4 Parsing](doc/parsing.md).

## Crawling the tree

See [Crawling the tree](doc/crawling.md)

## Handlers

The point of crawling the tree is to do something at each node.  That
is the responsibility of the node [Handlers](doc/handlers.md).

## Client Testing

See [Testing Parser Clients](doc/testing.clients.md) for information
about testing application-specific client code.

## Road map

* implement ANTLR visitors
* implement lein plugin
* implement lein template


## See also

[Getting Started with ANTRL v4](https://theantlrguy.atlassian.net/wiki/display/ANTLR4/Getting+Started+with+ANTLR+v4)
by Terrence Parr, the maniac behind ANTLR (his words, not mine!)

[Using Antlr from Clojure](http://www.nickpascucci.com/blog/2014/03/01/using-antlr-from-clojure/)
A blog post (March 2014) with a minimal example of how to parse Java files
using ANTLR 4 from Clojure, without the lein infrastructure we use.

[clj-antlr](https://github.com/aphyr/clj-antlr) is a more ambitious
effort to Clojurize ANTLR.


.
