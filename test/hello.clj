(ns hello
  (:import [org.antlr.v4.runtime DefaultErrorStrategy]
           [symLexer])
  (:require [clojure.test :refer :all]
            [org.mobileink.antlr :refer :all]
            [org.mobileink.antlr.lex :refer :all :as lex]
            [org.mobileink.antlr.parse :refer :all]))

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
  )

(defn teardown []
  )

(defn test-setup
  [f]
  (println "test setup")
  (setup)
  (f)
  (println "test teardown")
  (teardown))

(use-fixtures :once test-setup)

(deftest hello-1
  (testing "minimal symbol"
    (lex/lex-string "hello1" "abc def")))

(deftest hello-2
  (testing "minimal symbol"
    (lex/lex-file "hello1" "test/data/hello.txt" 'start)))

