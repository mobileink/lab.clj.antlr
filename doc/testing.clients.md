# Testing ANTLR parser clients

For example, in cider:

```
(org.mobileink.antlr/visit-str "(defn foo [bar] (+ bar 2)")
(org.mobileink.antlr/visit-file "test/clojure/test1.clj")
(org.mobileink.antlr/listen-str "(defn foo [bar] (+ bar 2)")
(org.mobileink.antlr/listen-file "test/clojure/test1.clj")
```
