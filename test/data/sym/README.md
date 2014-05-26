Clojure symbol syntax tests

The test files do not contain legal clojure programs, just symbols for
testing the sym grammar.

To test:

```
$ ./grun.sh sym 'start sym/sym01.clj
```

or

```
$ lein test sym
```

or from the repl:

```
user=> (load-file "src/clojure/org/mobileink/antlr/lex.clj")
user=> (alias 'lex 'org.mobileink.antlr.lex)
user=> (lex/lex-file "sym" "test/data/sym/sym01.clj")
```
