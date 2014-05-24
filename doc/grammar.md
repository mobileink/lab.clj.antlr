# ANTLR 4 Grammars

See the online docs for:

* [Grammar Structure](https://theantlrguy.atlassian.net/wiki/display/ANTLR4/Grammar+Structure)


### Splitting up a grammar into multiple files

See [Importing Grammars](https://theantlrguy.atlassian.net/wiki/display/ANTLR4/Grammar+Structure#GrammarStructure-GrammarImports).  See DA4R page 36, "Importing Grammars".

The syntax is simple:
```
import Foo ;
```

The import mechanism supports overrides; rules in the including
grammar override rules from imported grammars.  But it isn't clear (to
me) if that applies to *all* the rules in the including file, or only
those following the `import` statement.

If you want a file containing only lexical rules, make it start with
`lexer grammar` instead of just `grammar` (DA4R example p. 36).
