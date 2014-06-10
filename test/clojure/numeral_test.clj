(ns numeral_test
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

(deftest num-int-1
  (testing "int lit syntax"
    (is (nil? (clj/lex-string "0")))))

(deftest num-int-2
  (testing "int lit syntax 2"
    (is (nil? (clj/lex-string "-0")))))

(deftest num-int-3
  (testing "int int syntax"
    (is (nil? (clj/lex-string "1")))))

(deftest num-int-4
  (testing "int int syntax"
    (is (nil? (clj/lex-string "-1")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftest num-hex-1
  (testing "int hex syntax"
    (is (nil? (clj/lex-string "0x1")))))

(deftest num-hex-2
  (testing "int hex syntax"
    (is (nil? (clj/lex-string "-0x1")))))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftest num-radix-2
  (testing "int radix syntax"
    (is (nil? (clj/lex-string "2r1010")))))

;; (deftest num-radix-2-fail-1
;;   (testing "int radix syntax"
;;     (is (nil? (clj/lex-string "2r102")))))

;; (deftest num-radix-3
;;   (testing "int radix syntax"
;;     (is (nil? (clj/lex-string "3r1010")))))

;; (deftest num-radix-8
;;   (testing "int radix syntax"
;;     (is (nil? (clj/lex-string "8r14")))))

;; (deftest num-radix-16
;;   (testing "int radix syntax"
;;     (is (nil? (clj/lex-string "16rFF")))))

