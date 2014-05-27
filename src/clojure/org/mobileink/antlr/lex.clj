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
        tokens (CommonTokenStream. lxr)]
    (do
      (.fill tokens)
      (let
          [seqtoks (iterator-seq (.iterator (.getTokens tokens)))]
        (do
          (doall (map #(println (.getTokenIndex %) (.toString %))
                      seqtoks))
          ))))
  nil)

