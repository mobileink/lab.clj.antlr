# Introduction to Grammar Development with ANTLR and Clojure

## Components

`org.mobileink.antlr.lex` contains functions

* lex-string [grammar 'start string] :: load grammar and parse string starting with rule 'start
* lex-file   [grammar 'start filename] :: load grammar and parse file `filename`

## repl

From the project root: start a repl.  The load and alias the tools for
easy reference.

```
user=> (load-file "src/clojure/org/mobileink/antlr/lex.clj")
user=> (alias 'lex 'org.mobileink.antlr.lex)
user=> (lex/lex-string "sym" 'start ":a/b")
```

