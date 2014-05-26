#!/bin/sh

usage(){
	echo "usage: $ ./regen.sh <grammar>"
	echo "where <grammar> is the name of a grammar file without the extension"
	echo "requirement: grammar files must have extension .g4"
	exit 1
}

# call usage() function if filename not supplied
[[ $# -eq 0 ]] && usage

FILE=
if [ -f "src/antlr/$1.g4" ]
then
    FILE=src/antlr/$1.g4
else
    echo "No file src/antlr/$1.g4"
    exit 1
fi

set -x
## no lein clean, since we may want to test multiple parsers
./clean.sh && ./antlr4.sh $1 && lein javac;

