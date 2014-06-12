(ns numeral_test
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
    (is (= (clj/lex-string "0")
           '(DecimalNumeral EOF)))))

(deftest num-int-2
  (testing "int lit syntax 2"
    (is (= (clj/lex-string "-0")
           '(DecimalNumeral EOF)))))

(deftest num-int-3
  (testing "int int syntax"
    (is (= (clj/lex-string "1")
           '(DecimalNumeral EOF)))))

(deftest num-int-4
  (testing "int int syntax"
    (is (= (clj/lex-string "-1")
           '(DecimalNumeral EOF)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftest num-octal-1
  (testing "int octal syntax"
    (is (= (clj/lex-string "01")
           '(OctalNumeral EOF)))))
(deftest num-octal-2
  (testing "int octal syntax"
    (is (= (clj/lex-string "02")
           '(OctalNumeral EOF)))))
(deftest num-octal-3
  (testing "int octal syntax"
    (is (= (clj/lex-string "03")
           '(OctalNumeral EOF)))))
(deftest num-octal-4
  (testing "int octal syntax"
    (is (= (clj/lex-string "04")
           '(OctalNumeral EOF)))))
(deftest num-octal-5
  (testing "int octal syntax"
    (is (= (clj/lex-string "05")
           '(OctalNumeral EOF)))))
(deftest num-octal-6
  (testing "int octal syntax"
    (is (= (clj/lex-string "06")
           '(OctalNumeral EOF)))))
(deftest num-octal-7
  (testing "int octal syntax"
    (is (= (clj/lex-string "07")
           '(OctalNumeral EOF)))))
(deftest num-octal-8
  (testing "int octal syntax"
    (is (= (clj/lex-string "08")
           '(BadOctal EOF)))))
(deftest num-octal-9
  (testing "int octal syntax"
    (is (= (clj/lex-string "09")
           '(BadOctal EOF)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftest num-hex-1
  (testing "int hex syntax"
    (is (= (clj/lex-string "0x1")
           '(HexNumeral EOF)))))

(deftest num-hex-2
  (testing "int hex syntax"
    (is (= (clj/lex-string "-0x1")
           '(HexNumeral EOF)))))

(deftest num-hex-fail-1
  (testing "int hex syntax"
    (is (= (clj/lex-string "0xFG")
           '(BadHex EOF)))))

(deftest num-hex-fail-2
  (testing "int hex syntax"
    (is (= (clj/lex-string "+0xFG")
           '(BadHex EOF)))))

(deftest num-hex-fail-3
  (testing "int hex syntax"
    (is (= (clj/lex-string "-0xFG")
           '(BadHex EOF)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftest num-radix-2
  (testing "int radix syntax"
    (is (= (clj/lex-string "2r1010")
           '(RadixNumeral EOF)))))

(deftest num-radix-2-fail-1
  (testing "int radix syntax"
    (is (= (clj/lex-string "2r102")
           '(BadRadix EOF)))))

(deftest num-radix-3
  (testing "int radix syntax"
    (is (= (clj/lex-string "3r120")
           '(RadixNumeral EOF)))))

(deftest num-radix-8
  (testing "int radix syntax"
    (is (= (clj/lex-string "8r12345670")
           '(RadixNumeral EOF)))))

(deftest num-radix-8-fail
  (testing "int radix syntax"
    (is (= (clj/lex-string "8r78")
           '(BadRadix EOF)))))

(deftest num-radix-16-1
  (testing "int radix syntax"
    (is (= (clj/lex-string "16r123456789ABCDEF")
              '(RadixNumeral EOF)))))

(deftest num-radix-16-2
  (testing "int radix syntax"
    (is (= (clj/lex-string "16r123456789abcdef")
              '(RadixNumeral EOF)))))

(deftest num-radix-16-fail
  (testing "int radix syntax"
    (is (= (clj/lex-string "16rFG")
              '(BadRadix EOF)))))

(deftest num-radix-36-1
  (testing "int radix syntax"
    (is (= (clj/lex-string "36rXYZ")
              '(RadixNumeral EOF)))))

(deftest num-radix-36-2
  (testing "int radix syntax"
    (is (= (clj/lex-string "36rxyz")
              '(RadixNumeral EOF)))))

