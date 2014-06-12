(ns sexp_test
  (:import [org.antlr.v4.runtime DefaultErrorStrategy])
  (:require [clojure.test :refer :all]
            [org.mobileink.antlr :refer :all]
            [org.mobileink.antlr.clj :refer :all :as clj]))

;; TODO: drive verbose switch from param
(def verbose nil)

(def ers ;; error recovery strategy
  (proxy [DefaultErrorStrategy] []
    (recover [parser err] ;; recognizer and error
      )
    (recoverInline [parser]
      )
    (sync [parser]
      )))

;; (def lxrext
;;   (proxy [symLexer] []
;;     (recover [excpt]
;;       ;(throw RuntimeException. excpt)
;;     )))

(defn setup []
  (clj/make-parser "cljLexer" "cljParser"))

(defn teardown []
  )

(defn test-setup
  [f]
  (setup)
  (f)
  (teardown))

(use-fixtures :once test-setup)

(deftest sexp-1
  (testing "sexp list"
    (is (= (clj/lex-string "(a)")
           '(LPAREN SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(a b)")
           '(LPAREN SYM_NM WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(a b c)")
           '(LPAREN SYM_NM WS SYM_NM WS SYM_NM RPAREN EOF)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftest sexp-specials-1
  (testing "sexp list"
    (is (= (clj/lex-string "defn defmacro def do fn if let loop quote or recur var")
           '(SPECIAL WS SPECIAL WS SPECIAL WS SPECIAL WS SPECIAL WS SPECIAL WS SPECIAL WS SPECIAL WS SPECIAL WS SPECIAL WS SPECIAL WS SPECIAL EOF)))))

(deftest sexp-specials-2
  (testing "sexp list"
    (is (= (clj/lex-string "(def b c)")
           '(LPAREN SPECIAL WS SYM_NM WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(defn b c)")
           '(LPAREN SPECIAL WS SYM_NM WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(defmacro b c)")
           '(LPAREN SPECIAL WS SYM_NM WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(do b c)")
           '(LPAREN SPECIAL WS SYM_NM WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(fn b c)")
           '(LPAREN SPECIAL WS SYM_NM WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(let b c)")
           '(LPAREN SPECIAL WS SYM_NM WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(loop b c)")
           '(LPAREN SPECIAL WS SYM_NM WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(quote b c)")
           '(LPAREN SPECIAL WS SYM_NM WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(or b c)")
           '(LPAREN SPECIAL WS SYM_NM WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(recur b c)")
           '(LPAREN SPECIAL WS SYM_NM WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(var b c)")
           '(LPAREN SPECIAL WS SYM_NM WS SYM_NM RPAREN EOF)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftest sexp-specials-3
  (testing "sexp list with namespaces"
    (is (= (clj/lex-string "(def a/b c)")
           '(LPAREN SPECIAL WS SYM_NS SLASH SYM_NM
                    WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(defn a/b c)")
           '(LPAREN SPECIAL WS SYM_NS SLASH SYM_NM
                    WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(defmacro a/b c)")
           '(LPAREN SPECIAL WS SYM_NS SLASH SYM_NM
                    WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(do a/b c/d)")
           '(LPAREN SPECIAL WS SYM_NS SLASH SYM_NM
                    WS SYM_NS SLASH SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(fn a/b [] c)")
           '(LPAREN SPECIAL WS SYM_NS SLASH SYM_NM
                    WS LBRACK RBRACK WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(let [a/b c] d)")
           '(LPAREN SPECIAL WS LBRACK SYM_NS SLASH SYM_NM
                    WS SYM_NM RBRACK WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(loop a/b a/c)")
           '(LPAREN SPECIAL WS SYM_NS SLASH SYM_NM
                    WS SYM_NS SLASH SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(quote a/b c)")
           '(LPAREN SPECIAL WS SYM_NS SLASH SYM_NM
                    WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(or a/b c/d)")
           '(LPAREN SPECIAL WS SYM_NS SLASH SYM_NM
                    WS SYM_NS SLASH SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(recur a/b a/c)")
           '(LPAREN SPECIAL WS SYM_NS SLASH SYM_NM
                    WS SYM_NS SLASH SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(var a/b c/d)")
           '(LPAREN SPECIAL WS SYM_NS SLASH SYM_NM
                    WS SYM_NS SLASH SYM_NM RPAREN EOF)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftest sexp-embed
  (testing "sexp with embedded sexp"
    (is (= (clj/lex-string "(let [a b] c)")
           '(LPAREN SPECIAL WS LBRACK SYM_NM WS SYM_NM
                    RBRACK WS SYM_NM RPAREN EOF)))
    (is (= (clj/lex-string "(do (foo b) (bar c))")
           '(LPAREN SPECIAL WS LPAREN SYM_NM WS SYM_NM RPAREN
                    WS LPAREN SYM_NM WS SYM_NM RPAREN RPAREN EOF)))
    (is (= (clj/lex-string "(do (foo (bar b)))")
           '(LPAREN SPECIAL WS
                    LPAREN SYM_NM WS
                    LPAREN SYM_NM WS SYM_NM RPAREN RPAREN RPAREN EOF)))))
