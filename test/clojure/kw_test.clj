(ns kw_test
  (:import [org.antlr.v4.runtime DefaultErrorStrategy]
           [symLexer]
           )
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
  (clj/make-parser "cljLexer" "cljParser")
  )

(defn teardown []
  )

(defn test-setup
  [f]
  (setup)
  (f)
  (teardown))

(use-fixtures :once test-setup)

(deftest kw-min1
  (testing "minimal keyword w/o ns"
    (is (= (clj/lex-string ":a")
           '(KW_SENTINEL KW_NM EOF)))))

(deftest kw-min3
  (testing "minimal keyword with ns"
    (is (= (clj/lex-string ":a/b")
           '(KW_SENTINEL KW_NS SLASH KW_NM EOF)))))

(deftest kw-bad0
  (testing "numeric start char"
    (is (= (clj/lex-string ":9")
           "token recognition error at: '9'"))))

(deftest kw-bad1
  (testing "empty ns"
    (is (= (clj/lex-string ":/b")
           "token recognition error at: '/b'"))))

(deftest kw-trailing-colon-1
  (testing "trailing ':' w/o ns"
    (is (= (clj/lex-string ":a:")
           '(BAD_SYM_TERMINAL_COLON EOF)))))

(deftest kw-trailing-colon-2
  (testing "trailing ':' in ns"
    (is (= (clj/lex-string ":a:/b")
           '(BAD_SYM_TERMINAL_COLON EOF)))))

(deftest kw-trailing-colon-3
  (testing "trailing ':' in nm w/ns"
    (is (= (clj/lex-string ":a/b:")
           '(BAD_SYM_TERMINAL_COLON EOF)))))

(deftest kw-trailing-colon-4
  (testing "trailing ':' in ns and nm"
    (is (= (clj/lex-string ":a:/b:")
           '(BAD_SYM_TERMINAL_COLON EOF)))))

(deftest kw-embedded-colon-1
  (testing "embedded '::' in nm"
    (is (= (clj/lex-string ":a::b")
           '(BAD_SYM_COLONS_EMBEDDED EOF)))))

(deftest kw-embedded-colon-2
  (testing "embedded '::' in ns w/nm"
    (is (= (clj/lex-string ":a::b/c")
           '(BAD_SYM_COLONS_EMBEDDED EOF)))))

(deftest kw-embedded-colon-3
  (testing "embedded '::' in nm w/ns"
    (is (= (clj/lex-string ":a/b::c")
           '(BAD_SYM_COLONS_EMBEDDED EOF)))))

