#!/bin/sh

ANTLR=$MAVEN_REPO/org/antlr

usage(){
	echo "usage: $ antlr4 <grammar>"
	echo "where <grammar> is the name of a grammar file without the extension"
	echo "requirement: grammar files must have extension .g4"
	echo "result: generated .java files in src/java"
	exit 1
}

# call usage() function if filename not supplied
[[ $# -eq 0 ]] && usage

(cd src/antlr/clj; \
    java \
    -cp "$ANTLR/antlr4-runtime/4.2.2/antlr4-runtime-4.2.2.jar:$ANTLR/antlr4/4.2.2/antlr4-4.2.2.jar:$ANTLR/ST4/4.0.8/ST4-4.0.8.jar:$ANTLR/antlr-runtime/3.5.2/antlr-runtime-3.5.2.jar" \
    org.antlr.v4.Tool \
    -o ../../../src/java/clj \
    -listener \
    -visitor \
    $*.g4)

