# Crawling the Tree

First see [Push v. Pull](pushpull.md).

ANTLR 4 provides built-in support for the two basic crawling
strategies: passive cleint v. active client.

## Passive

By passive crawling I mean a method in which movement about the tree
is controlled by a service, and the client registers callbacks and
then passively awaits calls from the crawler.  This is also called the
listener or event-driven pattern.  Or push processing, since the
crawler pushes stuff to the client.

ANTRL generates a Listener interface (here,
src/java/grammar/ClojureListener.java) defining `enter<rule>` and
`exit<rule>` methods for each rule in the grammar -
e.g. `enterKeyword` and `exitKeyword` - and a `visitTerminal` method.
It also generates a null implementation of the interface (here,
ClojureBaseListener).  To passively crawl the tree using a SAX-like
strategy, just subclass the <FOO>BaseListener and implement the
methods you need.

See [src/clojure/org/mobileink/antlr.clj](src/clojure/org/mobileink/antlr.clj) for an example of how to do
this in Clojure using `proxy`.

## Active

By "active" crawling I mean a method in which the crawling is
controlled by the client.  Sometimes call pull processing since the
client actively controls the fetching of data and movement about the
tree.  ANTLR supports this as the "visitor pattern", but I have not
yet implemented this in Clojure.


