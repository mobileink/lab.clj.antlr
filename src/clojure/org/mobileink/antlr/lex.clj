(ns org.mobileink.antlr.lex
  (:require [criterium.core :as crit]
            [byte-streams :as bs])
  (:import [java.nio.ByteBuffer]
           [java.net URL URLClassLoader]
           [org.antlr.v4.runtime
            ANTLRInputStream
            ANTLRFileStream
            CharStream
            CommonTokenStream
            DefaultErrorStrategy
            DiagnosticErrorListener
            Lexer
            Parser
            ParserRuleContext
            TokenStream]
           [org.antlr.v4.runtime.atn PredictionMode]
           [org.antlr.v4.runtime.tree ParseTree ParseTreeWalker]
           [org.antlr.v4.runtime.misc TestRig]
           [clojure.lang DynamicClassLoader]))

;; ANTLR Lexer Javadoc:
;; http://www.antlr.org/api/Java-master/org/antlr/v4/runtime/Lexer.html

(def ^:dynamic *tokmap* (atom nil))
(def ^:dynamic *rulemap* (atom nil))

(defn- settoks [^String grammar]
  (let [lexname (str grammar "Lexer")
        lxr (eval `(new ~(Class/forName lexname) nil))
        toks (.getTokenNames lxr)
        tokmap (.getTokenTypeMap lxr)]
    (doall (map #(do
                   (swap!  *tokmap* assoc (.getValue %) (.getKey %))
                   ;;(println %)
                   )
                tokmap))
    ;; (doseq [[k v] (sort @*tokmap*)]
    ;;   (println k ": " v))
    nil))

(defn tokmap [^String grammar]
  (if (nil? @*tokmap*)
    (println (format "tokmap for %s not set; run lex-string to set it" grammar))
    (doseq [[k v] (sort @*tokmap*)]
      (println k ": " v))))

(defn- setrules [^String grammar]
  (let [lexname (str grammar "Lexer")
        lxr (eval `(new ~(Class/forName lexname) nil))
        rules (.getRuleNames lxr)
        rulemap (.getRuleIndexMap lxr)]
    ;;(doall (map (fn [[k v] %] (println k)) rulemap))
    (doall (map #(do
                   (swap!  *rulemap* assoc (+ 1 (.getValue %)) (.getKey %))
                   ;(println (+ 1(.getValue %)) (.getKey %))
                   )
                rulemap))
    nil))

(defn rule [^long i]
  (@*rulemap* i))

(defn rulemap [^String grammar]
  (if (nil? @*rulemap*)
    (println (format "rulemap for %s not set; run lex-string to set it" grammar))
    (doseq [[k v] (sort @*rulemap*)]
      (println k ": " v))))

(defn lex-file
  [^String grammar ;; e.g. "org.mobileink.antlr.sym"
   ^String file ;; file to parse
   ]
  (let [
        lexname (str grammar "Lexer")
        infile (ANTLRFileStream. file)
        lxr (eval `(new ~(Class/forName lexname) nil))
        devnull (.setInputStream lxr infile)
        ;; tokens (.getAllTokens lxr)) ;; list of all toks except EOF
        tokstream (CommonTokenStream. lxr) ;; indexed list of tokens
        ]
    (do
      (.fill tokstream)
      (let
          [seqtoks (iterator-seq (.iterator (.getTokens tokstream)))]
        (do
          (doall (map (fn [t] (print (format "%s\n" (.toString t))))
                      seqtoks))
          ))))
  nil)

(defn lex-string
  [^String grammar ;; e.g. "org.mobileink.antlr.sym"
   ^String the-string ;; file to scan
   ]
  (let [lexname (str grammar "Lexer")
        strinput (ANTLRInputStream. the-string)
        lxr (eval `(new ~(Class/forName lexname) nil))
        devnull (.setInputStream lxr strinput)
        tokens (CommonTokenStream. lxr)

        ;; parsername (str grammar "Parser")

        ;; foo (macroexpand `(new ~(Class/forName parsername)
        ;;                        (CommonTokenStream.
        ;;                         (new ~(Class/forName lexname)
        ;;                              (ANTLRInputStream. ~the-string)))))

        ;; parser (eval foo) ;;`(new ~(Class/forName parsername) #=tokens))

        ;; tree (do ;;(println "getting tree")
        ;;        (.id_kw parser)) ; method name = start rule in grammar
        ]

    (do
      (if (nil? @*tokmap*)
        (settoks grammar))
      (if (nil? @*rulemap*)
        (setrules grammar))
      (.fill tokens)
      (let
          [seqtoks (iterator-seq (.iterator (.getTokens tokens)))]
        (do
          (doall (map (fn [tok]
                        (print (format "%s  %s %s\n"
                                       (.toString tok)
                                       (.getType tok)
                                       (get @*tokmap* (.getType tok)))))
                      seqtoks))
          ;; (println (.toStringTree tree))
          ;;(println (.getText tree))
          ))))
  nil)

