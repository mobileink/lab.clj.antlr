# Node Handlers

When you crawl the tree, whether actively or passively, you must
provide methods to handle nodes.

In passive crawling, your handler can do whatever it wants with the
node, but it has no access to other nodes in the tree.  No
"get-parent" etc.

In active crawling, your handlers are responsible for more than just
handling the node.  They are also responsible for crawling the tree.

The general way to to this in ANTLER is to call the `visit` method,
passing the current context as argument.

> Note the parallel with standard XML processing.  The SAX method,
> wherein clients register "event" handlers with a service that is
> responsible for crawling the tree and calling handlers as it goes,
> corresponds to passive crawling.  

