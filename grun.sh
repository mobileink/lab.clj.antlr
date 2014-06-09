#!/bin/sh

## run antlr test rig
## TODO: move to lein plugin

ANTLR=$MAVEN_REPO/org/antlr

usage(){
    echo "usage: $ ./grun.sh <grammar> <start-rule> <output-type> [file]"
    echo "    where <output-type> == tokens (default) | tree | gui | ps <filename>"
    echo "    [file] == optional file to parse; omit it to enter expressions at command line"
    echo "To test the lexer only, use 'tokens' as the <start-rule>"
    echo "To see all options run without args:  $ ./grun.sh"
    echo "Example:"
    echo "$ ./grun.sh foo start tokens"
    echo "(+ 1 2)"
    echo "<ctrl-D>"

    echo "to see tool help:  ./grun.sh help"
    exit 1
}

if [[ "$1" == "help" ]]
then
    echo HELP
    java -cp ".:target/classes:$ANTLR/antlr4-runtime/4.2.2/antlr4-runtime-4.2.2.jar:$ANTLR/antlr4/4.2.2/antlr4-4.2.2.jar:$ANTLR/ST4/4.0.8/ST4-4.0.8.jar:$ANTLR/antlr-runtime/3.5.2/antlr-runtime-3.5.2.jar:$MAVEN_REPO/org/abego/treelayout/org.abego.treelayout.core/1.0.1/org.abego.treelayout.core-1.0.1.jar" org.antlr.v4.runtime.misc.TestRig work ;
    exit 1
fi

# call usage() function if filename not supplied
[[ $# -eq 0 ]] && usage

FILE=
OUTFMT=-tokens

# set -x

if [ -n "$3" ]
then
    case $3 in
	tokens)
	    OUTFMT=-$3
	    ;;
	tree)
	    OUTFMT=-$3
	    ;;
	gui)
	    OUTFMT=-$3
	    ;;
	ps)
	    OUTFMT=-$3
	    ;;
	*)
	    if [ -f "test/data/$3" ]
	    then
		FILE=test/data/$3
	    else
		echo "Invalid output format $3; must be one of: tokens, tree, gui, ps <filename>"
		exit 1
	    fi
    esac
fi

if [ -f "test/data/$4" ]
then
    FILE=test/data/$4
# else
    # echo $4 not found
    # exit 1
fi

# set -x
java -cp ".:target/classes:$ANTLR/antlr4-runtime/4.2.2/antlr4-runtime-4.2.2.jar:$ANTLR/antlr4/4.2.2/antlr4-4.2.2.jar:$ANTLR/ST4/4.0.8/ST4-4.0.8.jar:$ANTLR/antlr-runtime/3.5.2/antlr-runtime-3.5.2.jar:$MAVEN_REPO/org/abego/treelayout/org.abego.treelayout.core/1.0.1/org.abego.treelayout.core-1.0.1.jar" \
    org.antlr.v4.runtime.misc.TestRig \
    $1 \
    $2 \
    -diagnostics \
    $OUTFMT \
    $FILE;

