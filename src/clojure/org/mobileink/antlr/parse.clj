(ns org.mobileink.antlr.parse
  (:require [criterium.core :as crit])
  (:import [org.antlr.v4.runtime
            ANTLRInputStream
            ANTLRFileStream
            CharStream
            CommonTokenStream
            DiagnosticErrorListener
            Lexer
            Parser
            ParserRuleContext
            TokenStream]
           [org.antlr.v4.runtime.atn PredictionMode]
           [org.antlr.v4.runtime.tree ParseTree ParseTreeWalker]
           [org.antlr.v4.runtime.misc TestRig]))


;; (defmacro import-by-name [name] `(import [~name]))
;; (defmacro new-k [klass] `(new ~(Class/forName klass)))


;; Lexer Javadoc: http://www.antlr.org/api/Java-master/org/antlr/v4/runtime/Lexer.html

(defn parse-file
  [^String grammar ;; e.g. "org.mobileink.antlr.sym"
   rule ;; grammar rule symbol
   file ;; file to parse
   ]
  (let [
        lexname (str grammar "Lexer")
        infile (ANTLRFileStream. file)
        lxr (eval `(new ~(Class/forName lexname) nil))
        x (.setInputStream lxr infile)
        tokens (do (.reset lxr) (.getAllTokens lxr))
        ;; parsername (str grammar "Parser")
        ;; parsens (import-by-name parsername)
        ]
    (do
      (let [seqtoks (iterator-seq (.iterator tokens))]
        (do
          ;; (doall (map (fn [t] (format "%s: %s\n" (.getTokenIndex t) (.toString t)))
          ;;             seqtoks))
          (doall (map #(println (.getTokenIndex %) (.getType %) (.toString %)) seqtoks))
          )))))

(defn parse-string
  [^String grammar ;; e.g. "org.mobileink.antlr.sym"
   rule ;; grammar rule symbol
   the-string ;; file to parse
   ]
  (let [
        lexname (str grammar "Lexer")
        strinput (ANTLRInputStream. the-string)
        lxr (eval `(new ~(Class/forName lexname) nil))
        foo (.setInputStream lxr strinput)
        tokens (do (.reset lxr) (.getAllTokens lxr))
        ;; parsername (str grammar "Parser")
        ;; parsens (import-by-name parsername)
        ;;lex (.setInputStream (symbol (new (str grammar "Lexer"))) input)
        ]
    (do
      (let [seqtoks (iterator-seq (.iterator tokens))]
        (do
          (doall (map #(println (.toString %)) seqtoks))
      ))))
  ;;(println "end")
;;  (println "ns" (find-ns (symbol lexname))) ;;'org.mobileink.antlr.Hello1Lexer))
  )
