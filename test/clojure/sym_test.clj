(ns sym_test
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


(deftest sym-valid
  (testing "valid symbols"
    (is (= (clj/lex-string "a")
              '(SYM_NM EOF)))
    (is (= (clj/lex-string "a9")
              '(SYM_NM EOF)))
    (is (= (clj/lex-string "a/b")
           '(SYM_NS SLASH SYM_NM EOF)))
    (is (= (clj/lex-string "a/b9")
           '(SYM_NS SLASH SYM_NM EOF)))
    (is (= (clj/lex-string "a9/b9")
           '(SYM_NS SLASH SYM_NM EOF)))))

(deftest sym-ops
  (testing "syms consisting of ops e.g. / * etc."
    (is (= (clj/lex-string "+")
           '(MATHOP EOF)))
    (is (= (clj/lex-string "clojure.core/+")
           '(SYM_NS SLASH MATHOP EOF)))
    (is (= (clj/lex-string "-")
           '(MATHOP EOF)))
    (is (= (clj/lex-string "clojure.core/-")
           '(SYM_NS SLASH MATHOP EOF)))
    (is (= (clj/lex-string "*")
           '(MATHOP EOF)))
    (is (= (clj/lex-string "clojure.core/*")
           '(SYM_NS SLASH MATHOP EOF)))
    (is (= (clj/lex-string "/")
           '(MATHOP EOF)))
    (is (= (clj/lex-string "clojure.core//")
           '(SYM_NS SLASH MATHOP EOF)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  bad syms
(deftest sym-bad-terminal-colon
  (testing "bad syms: terminal colon disallowed"
    (is (= (clj/lex-string "a:")
           '(BAD_SYM_TERMINAL_COLON EOF)))
    (is (= (clj/lex-string "a:/b")
           '(BAD_SYM_TERMINAL_COLON EOF)))
    (is (= (clj/lex-string "a/b:")
           '(BAD_SYM_TERMINAL_COLON EOF)))
    (is (= (clj/lex-string "a:/b:")
           '(BAD_SYM_TERMINAL_COLON EOF)))))

(deftest sym-bad-embedded-colons
  (testing "bad syms: embedded '::'"
    (is (= (clj/lex-string "a::b")
           '(BAD_SYM_COLONS_EMBEDDED EOF)))
    (is (= (clj/lex-string "a::b/c")
           '(BAD_SYM_COLONS_EMBEDDED EOF)))
    (is (= (clj/lex-string "a/b::c")
           '(BAD_SYM_COLONS_EMBEDDED EOF)))
    (is (= (clj/lex-string "a::b/c::d")
           '(BAD_SYM_COLONS_EMBEDDED EOF)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftest sym-macro-chars
  (testing "value syms with non-terminal macro chars"
    (is (= (clj/lex-string "a#c")
           '(SYM_NM EOF)))
    (is (= (clj/lex-string "a%c")
           '(SYM_NM EOF)))
    (is (= (clj/lex-string "a'c")
           '(SYM_NM EOF)))))

(deftest sym-bad-macro-chars
  (testing "bad syms containing terminating macro chars"
    (is (= (clj/lex-string "a\"b")
           '(BAD_SYM_MACRO EOF)))
    (is (= (clj/lex-string "a`b")
           '(BAD_SYM_MACRO EOF)))
    (is (= (clj/lex-string "a~c")
           '(BAD_SYM_MACRO EOF)))
    (is (= (clj/lex-string "a;b")
           '(BAD_SYM_MACRO EOF)))
    (is (= (clj/lex-string "a\\b")
           '(BAD_SYM_MACRO EOF)))
    (is (= (clj/lex-string "a@b")
           '(BAD_SYM_MACRO EOF)))
    (is (= (clj/lex-string "a^c")
           '(BAD_SYM_MACRO EOF)))))

(deftest sym-bad-macro-chars-ns
  (testing "bad ns syms containing terminating macro chars"
    (is (= (clj/lex-string "a/b\"c")
           '(BAD_SYM_MACRO EOF)))
    (is (= (clj/lex-string "a/b`c")
           '(BAD_SYM_MACRO EOF)))
    (is (= (clj/lex-string "a/b~c")
           '(BAD_SYM_MACRO EOF)))))


