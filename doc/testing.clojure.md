# Testing ANTLR 4 Lexers/Parsers with Clojure

## Lex testing

See [Lexing](lexing.md).

### Components

[org.mobileink.antlr.lex](../src/clojure/org/mobileink/antlr/lex.clj) contains functions

* lex-string [grammar string] :: load grammar and parse string starting with rule 'start
* lex-file   [grammar filename] :: load grammar and parse file `filename`

### repl

From the project root: start a repl.  Then load and alias the tools for
easy reference.

```
user=> (load-file "src/clojure/org/mobileink/antlr/lex.clj")
user=> (alias 'lex 'org.mobileink.antlr.lex)
user=> (lex/lex-string "hello" "hello Jones")
user=> (lex/lex-file "hello" "test/data/hello.txt")
```

This is an efficient way to exercise a grammar; edit the test file, then rerun the lex/lex-file function.

To test the grammar, the repl doesn't do much good -
you have to restart it every time you change and recompile the grammar.  So the 
better approach is to use `./grun.sh`.  So the steps are:

1.  Edit the grammar
2.  run ./regen.sh from the project root
3.  run ./grun.sh from the project root
4.  goto step 1

Not quite as convenient as Clojure with a repl, but it works, and its reasonbly fast.
