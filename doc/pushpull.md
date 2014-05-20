# Parsing Strategies:  Push v. Pull v. ???

In the XML world, we have so-called "push" and "pull" parsing, and
maybe something in between.  Strictly speaking this is an abuse of
terminology, since whether you are pushing or pulling depends on your
perspective, and the usual classification switches horses in
midstream.

Sometimes the difference is cast in terms of the difference between
streaming and building the parse tree in memory.  This is a misleading
distinction.  Parsers can combine either push or pull with either
in-memory or streaming strategies.  SAX and StAX both adopt a
streaming strategy, but the former is a pull API and the latter is a
push API.  By the same token, a processor that builds a parse tree and
stores it in memory can support either a push or a pull API.  ANTLR4
fits in this category.

So there are two orthogonal axes: push v. pull API, and in-memory
parse tree v. streaming implementation (transient parse structures).

Or in other words, push/pull is an API design point; in-memory/stream
is an implementation point.

### Push Parsing

The classic example of a "push" API is
[SAX](http://www.saxproject.org/) (**S**imple **A**PI for **X**ML).
Presumably because the crawler service calls registered callbacks,
passing nodes as arguments, which looks like pushing data to the
client, metaphorically at least.  So there are two aspects to "push":
control of crawling, and control of data flow.  Under the push model,
the service controls both the crawling and the data flow, "pushing"
data to the client.

The advantage of this model is that it does not require that the parse
tree be stored in memory.  The parser can just proceed from beginning
to end, push data as it goes.

### Pull Parsing

[On Using XML Pull Parsing Java APIs](http://xmlpull.org/history/index.html)
discusses a variety of XML pull APIs.


So-called "pull" APIs make the client responsible for crawling the
tree and demanding data.  The client effectively tells the service
"give me the current node" and then "give me the first child (or
whatever) node": hence, the client "pulls" data from the service.  So
the roles are reverse: the client is active, and the service is
passive.  (Or maybe we should say "active" and "co-active".)  Again we
have a dualism: pull parsing means the client controls both the
crawling and the data flow, "pulling" data from the service.

Note the that direction of data flow is the same in both cases:
service to client.  The difference lies in who initiates data
transfer.

### Hybrid

XSLT is effectively a hybrid API.  You register event-driven
callbacks, but instead of registering them for a predefined set of
events, you register you handlers by specifying "match" patterns.  As
the processor crawls the tree it calls the handler with the best
match.  But the handler also controls crawling: if it calls
apply-templates or another of the "continue" routines, then crawling
proceeds; otherwise it stops, at least on that branch of the tree.
And it can force continuation of crawling at any place in the tree by
using an XPATH expression to obtain a reference to a node and then
directing the crawler to continue at that node.

