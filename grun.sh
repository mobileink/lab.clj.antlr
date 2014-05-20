#!/bin/sh

## run antlr test rig
## TODO: move to lein plugin

## usage:
## $ ./grun.sh org.mobileink.antrl.Clojure file -tokens
## (+ 1 2)
## <ctrl-D>

ANTLR=$MAVEN_REPO/org/antlr

java -cp ".:target/classes:$ANTLR/antlr4-runtime/4.2.2/antlr4-runtime-4.2.2.jar:$ANTLR/antlr4/4.2.2/antlr4-4.2.2.jar:$ANTLR/ST4/4.0.8/ST4-4.0.8.jar:$ANTLR/antlr-runtime/3.5.2/antlr-runtime-3.5.2.jar:$MAVEN_REPO/org/abego/treelayout/org.abego.treelayout.core/1.0.1/org.abego.treelayout.core-1.0.1.jar" \
    org.antlr.v4.runtime.misc.TestRig \
    $*;
