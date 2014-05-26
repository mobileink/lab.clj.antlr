Clojure symbol syntax tests

The test files do not contain legal clojure programs, just symbols for
testing the sym grammar.

To test:

```
$ ./grun.sh sym 'start sym/sym01.clj
```

or

```
$ lein test sym-test
```
