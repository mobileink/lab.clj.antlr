(ns org.mobileink.antlr
  (:require [criterium.core :as crit])
  (:import ;;[org.mobileink.antlr ClojureLexer ClojureParser ClojureBaseListener] ;ClojureBaseVisitor
           [org.antlr.v4.runtime ANTLRInputStream ANTLRFileStream CommonTokenStream]
           [org.antlr.v4.runtime.tree ParseTree ParseTreeWalker]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; utilities

;; (defn- text [ctx]
;;   (.getText (.start ctx)))

;; (defn- char-nbr [ctx]
;;   (.getCharPositionInLine (.start ctx)))

;; (defn- line-nbr [ctx]
;;   (.getLine (.start ctx)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defn- visitor [parser]
;;     (proxy [ClojureBaseVisitor] []
;;     (visitFile [ctx]
;;       (do
;;         (println "visiting file")
;;         (.visitChildren this ctx)
;;         ))
;;     (visitForm [ctx]
;;       (do
;;         (println (format "visiting form %s" (.getText ctx)))
;;         (.visitChildren this ctx)
;;         ))
;;     (visitLet [ctx]
;;       (do
;;         (println "visiting Let")
;;         (.visitChildren this ctx)
;;         ))
;;     (visitTerminal [ctx]
;;       (do
;;         (println "visiting terminal node")
;;         (println "\tsym: " (.getText (.getSymbol ctx)))
;;         ))
;;     ))

;; (defn visit-file [file]
;;   "Parse file 'file and crawl it using active client strategy."
;;   (print (format "visiting %s\n" file))
;;   (let [input (do ;;(println "getting stream")
;;                 ;; use ANTLRInputStream to read from a string buffer
;;                 (ANTLRFileStream. file))
;;         lexer (do ;;(println "getting lexer")
;;                   (ClojureLexer. input))
;;         tokens (do
;;                  ;;(println "getting tokens")
;;                  (CommonTokenStream. lexer))
;;         parser (do
;;                  ;;(println "getting parser")
;;                  (ClojureParser. tokens))
;;         tree (do ;;(println "getting tree")
;;                (.file parser))] ; "file" is the start rule of the grammar
;;     (do
;;       (.visit (visitor parser) tree))))

;; (defn visit-str [str]
;;   "Parse string 'str and crawl it using active client strategy."
;;   (print (format "visiting %s\n" str))
;;   (let [input (do ;;(println "getting stream")
;;                 (ANTLRInputStream. str))
;;         lexer (do ;;(println "getting lexer")
;;                   (ClojureLexer. input))
;;         tokens (do
;;                  ;;(println "getting tokens")
;;                  (CommonTokenStream. lexer))
;;         parser (do
;;                  ;;(println "getting parser")
;;                  (ClojureParser. tokens))
;;         tree (do ;;(println "getting tree")
;;                (.file parser))] ; "file" is the start rule of the grammar
;;     (do
;;       (.visit (visitor parser) tree))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defn- listener [] ;; [parser]
;;     (proxy [ClojureBaseListener] []
;;       ;; (enterEveryRule [ctx]
;;       ;;   (do
;;       ;;     (println "entering rule")
;;       ;;     ;; (println (format "ctx id: %s" (.Identifier ctx)))
;;       ;;     ;; (println (format "form: %s" (.form ctx)))
;;       ;;     ))
;;       ;; (exitEveryRule [ctx] (println "exiting rule"))
;;       (enterLet [ctx]
;;         (do
;;           (format "LET : '%s' start: %s end: %s\n" (text ctx) (char-nbr ctx) (line-nbr ctx))
;;             ))
;;       (exitLet [ctx] (do
;;                        (format "/LET: %s" (text ctx))))
;;       (enterLet_form [ctx]
;;         (do 
;;             (format "let_form : ");; (text ctx))
;;             ))
;;       (exitLet_form [ctx] (println "exiting let form"))
;;       (enterList [ctx] (println "LIST"))
;;       (exitList [ctx] (println "/LIST"))
;;       (visitTerminal [leaf]
;;         (do
;;           (print (format "terminal %s\n" (.getText (.getSymbol leaf))))
;;           ))
;;       ))

;; (defn listen-str [str]
;;   "Parse string 'str and crawl it using a passive strategy"
;;   (print (format "parsing %s\n" str))
;;   (let [input (do ;;(println "getting stream")
;;                 (ANTLRInputStream. str))
;;         lexer (do ;;(println "getting lexer")
;;                   (ClojureLexer. input))
;;         tokens (do
;;                  ;;(println "getting tokens")
;;                  (CommonTokenStream. lexer))
;;         parser (do
;;                  (println "getting parser")
;;                  (ClojureParser. tokens))
;;         tree (do ;;(println "getting tree")
;;                (.file parser))] ; "file" is the start rule of the grammar
;;     (do
;;       (.walk (ParseTreeWalker.) (listener) tree))))

;; (defn listen-file [file]
;;   "Parse file 'file and crawl it using a passive strategy"
;;   (print (format "parsing %s\n" file))
;;   (let [input (do ;;(println "getting stream")
;;                 ;; use ANTLRInputStream to read from a string buffer
;;                 (ANTLRFileStream. file))
;;         lexer (do ;;(println "getting lexer")
;;                   (ClojureLexer. input))
;;         tokens (do
;;                  ;;(println "getting tokens")
;;                  (CommonTokenStream. lexer))
;;         parser (do
;;                  (println "getting parser")
;;                  (ClojureParser. tokens))
;;         tree (do ;;(println "getting tree")
;;                (.file parser))] ; "file" is the start rule of the grammar
;;     (do
;;       (.walk (ParseTreeWalker.) (listener) tree))))

