(ns org.mobileink.antlr.clj
  (:require [criterium.core :as crit]
            [byte-streams :as bs]
            )
  (:import cljLexer
           [java.nio.ByteBuffer]
           [java.net URL URLClassLoader]
           [org.antlr.v4.runtime
            ANTLRInputStream
            ANTLRFileStream
            BaseErrorListener
            CharStream
            CommonTokenStream
            DefaultErrorStrategy
;;            DiagnosticErrorListener
            Lexer
            LexerNoViableAltException
            Parser
            ParserRuleContext
            Recognizer
            RecognitionException
            TokenStream]
           [org.antlr.v4.runtime.atn PredictionMode]
           [org.antlr.v4.runtime.tree ParseTree ParseTreeWalker]
           [org.antlr.v4.runtime.misc TestRig]
           [clojure.lang DynamicClassLoader]))

;; ANTLR Lexer Javadoc:
;; http://www.antlr.org/api/Java-master/org/antlr/v4/runtime/Lexer.html

(def ^:dynamic *lexer* (atom nil))
(def ^:dynamic *tokmap* (atom nil))

(defn- settoks [^String lexis]
  (let [lexname lexis
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

(defn tok [^long i]
  (@*tokmap* i))

(def ^:dynamic *dirty* (atom nil))

(defn make-lexer
  [^String lexis]
  (if (nil? @*lexer*)
    (let [;;lxr (eval `(new ~(Class/forName lexis) nil))
          lxrx (proxy [cljLexer] [nil]
                 ;;(recover [^LexerNoViableAltException e]
                 ;; (recover [^RecognitionException e]
                 ;;   (println "LEXER EXCEPTION")
                 ;;   (throw (new RuntimeException e)))
                 )

          error-listener (proxy [BaseErrorListener]  []
                           (syntaxError [^Lexer r
                                         ^Object badsym
                                         line
                                         col
                                         msg
                                         ^RecognitionException e]
                             ;; only save most recent error
                             (reset! *dirty* msg)
                             ;; (print "LEX ERROR: ")
                             (println "r: " r)
                             (println "r: " (.getToken r))
                             (println "r: " (.getText r))
                             ;; (doseq [item (.getTokenNames r)]
                             ;;            (println "toknm: " item))
                             (println "badtok: " (.getOffendingToken
                                                  e))
                             ;;(println "obj: " badsym)
                             ;; (println "line: " line)
                             ;; (println "col:  " col)
                             (println msg)
                             ;; (println "e: " (.toString e))

;; TODO: make it return err code rather than throw exception
;; so that clojure.test works nicely
                             ;(throw e)
                             ))
          ;; parser (eval  `(->>
          ;;                 ::tokens
          ;;                 ;;(CommonTokenStream. @*lexer*)
          ;;                 (mk-parser ~(Class/forName p))))

          ;; TODO: use start-rule here
          ]
      (.removeErrorListeners lxrx)
      ;;(println error-listener)
      (.addErrorListener lxrx error-listener)
      (swap! *lexer* (fn [x] lxrx))))
  (if (nil? @*tokmap*)
    (settoks lexis)))

(defn lex-file
  [^String file]
  (if (nil? @*lexer*)
    (println "lexer not set up")
    (let [infile (ANTLRFileStream. file)
          devnull (.setInputStream @*lexer* infile)
          tokens (CommonTokenStream. @*lexer*)]
      (do
        (.fill tokens)
        (let
            [seqtoks (iterator-seq (.iterator (.getTokens tokens)))]
          (do
            (doall (map (fn [t] (print (format "%s\n" (.toString t))))
                        seqtoks))
          )))))
  nil)

(defn lex-string
  [^String the-string
   & {:keys [mode] :or {mode :quiet}}]
  (swap!  *dirty* (fn [x] nil))
  (if (nil? @*lexer*)
    (println "lexer not set up")
    (let [strinput (ANTLRInputStream. the-string)
          devnull (.setInputStream @*lexer* strinput)
          tokens (CommonTokenStream. @*lexer*)]
      (.fill tokens)

      ;; TODO: return non-nil on scan exception

      (if (= mode :quiet)
        (do)
        (do
          (println "text: " the-string)
          (let
              [seqtoks (iterator-seq (.iterator (.getTokens tokens)))]
            (do
              (doall (map (fn [tok]
                            (print (format "lex: %s  %s %s\n"
                                           (.toString tok)
                                           (.getType tok)
                                           (get @*tokmap* (.getType tok)))))
                          seqtoks))
              ;; (println (.toStringTree tree))
              ;;(println (.getText tree))
             ))))))
  @*dirty*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(def ^:dynamic *parser* (atom nil))
(def ^:dynamic *rulemap* (atom nil))

(defn- setrules [^String syntaxis]
  (let [lexname syntaxis ;; (str syntaxis "Lexer")
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

(defn rulemap [^String syntaxis]
  (if (nil? @*rulemap*)
    (println (format "rulemap for %s not set; run lex-string to set it" syntaxis))
    (doseq [[k v] (sort @*rulemap*)]
      (println k ": " v))))

(defn make-parser
  [^String lexis
   ^String syntaxis]
  (if (nil? @*lexer*)
    (make-lexer lexis))
  (if (nil? @*parser*)
      (swap! *parser* (fn [x] syntaxis))))

(defn parse-string
  [^String the-string
   ;; start-rule
   & {:keys [mode] :or {mode :quiet}}]
  (if (nil? @*lexer*)
    (println "lexer not set up")
    (if (nil? @*parser*)
      (println "parser not set up")
      (let [strinput (ANTLRInputStream. the-string)
            devnull (.setInputStream @*lexer* strinput)
            tokens (CommonTokenStream. @*lexer*)

            ;; parser (eval `(->>
            ;;                ~the-string
            ;;                ANTLRInputStream.
            ;;                (foo cljParser)
            ;;                ;;CommonTokenStream.
            ;;                ;;(fn [toks] (new ~(Class/forName @*parser*) toks))
            ;;                ))

            parser (eval `(new ~(Class/forName @*parser*)
                               (CommonTokenStream. @*lexer*)))
                               ;;tokens))
            error-listener (proxy [BaseErrorListener]  []
                               (syntaxError [^Recognizer r
                                             ^Object badsym
                                             line
                                             col
                                             msg
                                             ^RecognitionException e]
                                 (println "PARSER ERROR")
                                 (println "obj: " badsym)
                                 (println "line: " line)
                                 (println "col:  " col)
                                 (println "msg: " msg)
                                            ))
            ]
        (.removeErrorListeners parser)
        ;(println error-listener)
        (.addErrorListener parser error-listener)
        (let [tree (.start parser)]     ; TODO: pass start rule as param
          (if (= mode :quiet)
            (do)
            (do
              (println "text: " the-string)
              (println "parse: " (.toString tree parser))))))
        ;; TODO: return non-nil on parse exception
        )))
  ;; (if (nil? @*rulemap*)
  ;;   (setrules syntaxis))
  ;;     (let


  ;;         [seqtoks (iterator-seq (.iterator (.getTokens tokens)))]
  ;;       (do
  ;;         (doall (map (fn [tok]
  ;;                       (print (format "%s  %s %s\n"
  ;;                                      (.toString tok)
  ;;                                      (.getType tok)
  ;;                                      (get @*tokmap* (.getType tok)))))
  ;;                     seqtoks))
  ;;         ;; (println (.toStringTree tree))
  ;;         ;;(println (.getText tree))
  ;;         ))))
  ;; nil)
