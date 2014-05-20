#!/bin/sh

## $ antlr4 -lib src/grammar -o src/java src/grammar/Clojure.g4

ANTLR=$MAVEN_REPO/org/antlr

(cd src/grammar;java -cp "$ANTLR/antlr4-runtime/4.2.2/antlr4-runtime-4.2.2.jar:$ANTLR/antlr4/4.2.2/antlr4-4.2.2.jar:$ANTLR/ST4/4.0.8/ST4-4.0.8.jar:$ANTLR/antlr-runtime/3.5.2/antlr-runtime-3.5.2.jar" org.antlr.v4.Tool $*)
