# Parsing Strategies:  Push v. Pull v. ???

> See also [Push, Pull, Next!](http://www.xml.com/pub/a/2005/07/06/tr.html) (Bob DuCharme)

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

## Misconceptions

You can find stuff on the web that talks about "DOM parsing".  There
is no such thing.  The DOM is an API that has nothing to do with
parsing.

But wait, you say; "DOM" stands for Document *Object* Model.  That's
not an API, it's an abstract model of a structure!  Oracle
[says so explicitly](http://docs.oracle.com/cd/B28359_01/appdev.111/b28394/adx_j_parser.htm#CCHCCEHA):
"DOM is an in-memory tree representation of the structure of an XML
document."  To which I reply: piffle!  The DOM is _entirely_ defined
in terms of the DOM API.  The W3C and Java folks are just confused
about the distinction between language, structure, and model.  The DOM
is defined entirely in terms of an API; it's a *language* (i.e. API,
aka signature).  The implementation behind a DOM API can have *any*
structure, so long as it can support the DOM operations.  You can do
this, at least in principle, with data structures that bear no
resemblance to the DOM "object model".

This confusion is enhanced by calling parsers "DOM parsers"
(e.g. Mozilla's
[DOMParser](https://developer.mozilla.org/en-US/docs/Web/API/DOMParser)),
which "can parse XML or HTML source stored in a string into a DOM
Document."  Well, it depends on what you mean by "DOM Document".  If
you mean "something that supports the DOM API", then fine; but if you
mean "an in-memory DOM (=tree?) representation of the source document,
then, no.  What it does is parse an input document and translate it
into *some* data structure, which an allied piece of software can
access using the DOM *API*.  The internals of the data structre are
*totally irrelevant*; what matters is that whatever it comes up with
will be "understood" by the client-facing DOM API implementation
responsible for turning DOM calls into data.

Or to put it more bluntly: you could support the DOM API with a purely
streaming parser, so long as you are willing to parse the thing
repeatedly and store lots of state information.  That would be
preposterous, but from the client perpective it would count as a "DOM
Document".

> TODO: this really has to do with adoption of an algebraic
> perspective on programming and data structures.  Which sounds all
> high-falootin' and fancy and all; but in fact it is incredibly
> useful in practice.

It might be objected that this is just what "model" means in "Document
Object Model": a formal, algebraic structure that is a model of the
"object" structure of the document.  But I don't think that is
accurate.  It gets things backwards.  In Ordinary Language, models
represent reality: a map is a model of a territory.  The notion of DOM
as a "document object model" (should that be parsed "(document object)
model or (document (object model)?)" is like that: the DOM is a
"picture" of the document.  But this is backwards.  Model theory
reverses this relationship between language and world.  For example,
the language of Group Theory is not a model of groups; just the
opposite, different groups are models of the language.  So it won't do
to call the DOM API a model of anything; it's just a piece of
language, a signature.  It would have been more accurate to call it
the Document Algebra Signature or the like.

> Note that the DOM API is a pull API, not a third type of API, as is
> sometimes claimed.  If you use a DOM API to manipulate an XML
> document, you are responsible for managing traversal of the tree and
> fetching data from it: the pull model - which means *active*
> traversal.



