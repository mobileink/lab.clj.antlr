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
  (testing "minimal keyword"
    (nil? (clj/lex-string ":9"))))

(deftest kw-min2
  (testing "minimal keyword with ns"
    (nil? (clj/lex-string ":a/b"))))

(deftest kw-min3
  (testing "parse minimal keyword with ns"
    (nil? (clj/parse-string "[:a/b 0]"))))

