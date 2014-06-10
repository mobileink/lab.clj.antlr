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
    (is (nil? (clj/lex-string ":a")))))

(deftest kw-min3
  (testing "minimal keyword with ns"
    (is (nil? (clj/lex-string ":a/b")))))

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
           "token recognition error at: 'a:'"))))

(deftest kw-trailing-colon-2
  (testing "trailing ':' in ns"
    (is (= (clj/lex-string ":a:/b")
           "token recognition error at: '/b'"))))

(deftest kw-trailing-colon-3
  (testing "trailing ':' in nm w/ns"
    (is (= (clj/lex-string ":a/b:")
           "token recognition error at: 'b:'"))))

(deftest kw-trailing-colon-4
  (testing "trailing ':' in ns and nm"
    (is (= (clj/lex-string ":a:/b:")
           "token recognition error at: 'b:'"))))

(deftest kw-embedded-colon-1
  (testing "embedded '::' in nm"
    (is (= (clj/lex-string ":a::b")
           "token recognition error at: 'a::b'"))))

(deftest kw-embedded-colon-2
  (testing "embedded '::' in ns w/nm"
    (is (nil? (clj/lex-string ":a::b/c")))))

(deftest kw-embedded-colon-3
  (testing "embedded '::' in nm w/ns"
    (is (= (clj/lex-string ":a/b::c")
           "token recognition error at: 'b::c'"))))

