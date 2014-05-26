# Testing ANTLR 4 Lexers/Parsers with Clojure

## Lexing

See [Lexing](lexing.md).

### Components

[org.mobileink.antlr.lex](../src/clojure/org/mobileink/antlr/lex.clj) contains functions

* lex-string [grammar string] :: load grammar and parse string starting with rule 'start
* lex-file   [grammar filename] :: load grammar and parse file `filename`

### repl

From the project root: start a repl.  The load and alias the tools for
easy reference.

```
user=> (load-file "src/clojure/org/mobileink/antlr/lex.clj")
user=> (alias 'lex 'org.mobileink.antlr.lex)
user=> (lex/lex-string "hello" "hello Jones")
user=> (lex/lex-file "hello" "test/data/hello.txt")
```

