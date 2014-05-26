(ns org.mobileink.antlr.lex
  (:require [criterium.core :as crit])
  (:import [org.antlr.v4.runtime
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
           [org.antlr.v4.runtime.misc TestRig]))

;; ANTLR Lexer Javadoc: http://www.antlr.org/api/Java-master/org/antlr/v4/runtime/Lexer.html

(defn lex-file
  [^String grammar ;; e.g. "org.mobileink.antlr.sym"
   ^String file ;; file to parse
;;   rule ;; grammar rule symbol
   ]
  (let [
        lexname (str grammar "Lexer")
        infile (ANTLRFileStream. file)
        lxr (eval `(new ~(Class/forName lexname) nil))
        x (.setInputStream lxr infile)
        ;; we can get tokens directly from lexer:
        ;; tokens (do (.reset lxr) (.getAllTokens lxr))
        ;; but they don't have token index
        ;; token streams keep track of token indices:
        tokens (CommonTokenStream. lxr)
        ;; ;; parsername (str grammar "Parser")
        ;; ;; parsens (import-by-name parsername)
        ;; parser (do
        ;;          (println "getting parser")
        ;;          (ClojureParser. tokens))
        ]
    (do
      (.fill tokens)
;      (println "tokens: " (class tokens))
      (let
          [seqtoks (iterator-seq (.iterator (.getTokens tokens)))]
        (do
          (doall (map (fn [t] (print (format "%s\n" (.toString t))))
                      seqtoks))
          ))))
  nil)

(defn lex-string
  [^String grammar ;; e.g. "org.mobileink.antlr.sym"
   ^String the-string ;; file to parse
   ;; rule ;; grammar rule symbol
   ]

  ;; TODO:  proxy <grammar>Lexer

  (let [
        lexname (str grammar "Lexer")
        strinput (ANTLRInputStream. the-string)
        lxr (eval `(new ~(Class/forName lexname) nil))
        foo (.setInputStream lxr strinput)
        ;; tokens (do (.reset lxr) (.getAllTokens lxr))
        tokens (CommonTokenStream. lxr)
        ;; parsername (str grammar "Parser")
        ;; parsens (import-by-name parsername)
        ;;lex (.setInputStream (symbol (new (str grammar "Lexer"))) input)
        ]
    (do
      (.fill tokens)
      (let
          [seqtoks (iterator-seq (.iterator (.getTokens tokens)))]
        (do
          (doall (map #(println (.getTokenIndex %) (.toString %))
                      seqtoks))
          ))))
  nil)
