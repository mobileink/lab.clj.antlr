(ns antlr-test
  (:require [clojure.test :refer :all]
            [org.mobileink.antlr :refer :all]
            [org.mobileink.antlr.lex :refer :all :as lex]
            [org.mobileink.antlr.parse :refer :all]))


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

(deftest sym01
  (testing "minimal symbol"
    (lex/lex-string "sym" 'start "abc")))
    ;; (is (= 0 1))))
