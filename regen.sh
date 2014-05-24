#!/bin/sh

set -x
./clean.sh && ./antlr4.sh $1 && lein clean && lein javac;

