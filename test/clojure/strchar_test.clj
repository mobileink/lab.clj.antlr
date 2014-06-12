(ns strchar_test
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

(deftest char-1
  (testing "sym a"
    (is (= (clj/lex-string "\\a")
              '(CharacterLiteral EOF)))))

(deftest char-newline
  (testing "char newline"
    (is (= (clj/lex-string "\\newline")
              '(CharacterLiteral EOF)))))

(deftest char-unicode
  (testing "unicode chars"
    (is (= (clj/lex-string "\\u03C0")    ; pi
              '(CharacterLiteral EOF)))))

(deftest str-1
  (testing "sym a"
    (is (= (clj/lex-string "\"abc\"")
              '(StringLiteral EOF)))))

(deftest str-escapes
  (testing "strings with embedded esc chars"
    (is (= (clj/lex-string "\"a\tc\"")
              '(StringLiteral EOF)))
    (is (= (clj/lex-string "\"a\rc\"")
              '(StringLiteral EOF)))
    (is (= (clj/lex-string "\"a\nc\"")
              '(StringLiteral EOF)))
    (is (= (clj/lex-string "\"a\bc\"")
              '(StringLiteral EOF)))))

(deftest str-unicode-latin-1
  (testing "unicode latin 1"
    (is (= (clj/lex-string "\"ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏ\"")
              '(StringLiteral EOF)))))

(deftest str-unicode-escapes
  (testing "unicode latin 1"
    (is (= (clj/lex-string "\"À\tÇ\"")  ; tab
              '(StringLiteral EOF)))
    (is (= (clj/lex-string "\"À\u03C0Ç\"") ; pi
              '(StringLiteral EOF)))))

(deftest str-unicode-latin-extended-a-1
  (testing "unicode latin extended a 1"
    (is (= (clj/lex-string "\"ĀāĂăĄąĆćĈĉĊċČčĎď\"")
              '(StringLiteral EOF)))
    (is (= (clj/lex-string "\"ĐđĒēĔĕĖėĘęĚěĜĝĞğ\"")
              '(StringLiteral EOF)))
    (is (= (clj/lex-string "\"ĠġĢģĤĥĦħĨĩĪīĬĭĮį\"")
              '(StringLiteral EOF)))
    (is (= (clj/lex-string "\"İıĲĳĴĵĶķĸĹĺĻļĽľĿ\"")
              '(StringLiteral EOF)))
    (is (= (clj/lex-string "\"ŀŁłŃńŅņŇňŉŊŋŌōŎŏ\"")
              '(StringLiteral EOF)))))

;; etc. extended a:
;; ŐőŒœŔŕŖŗŘřŚśŜŝŞş
;; 0160ŠšŢţŤťŦŧŨũŪūŬŭŮů
;; 0170ŰűŲųŴŵŶŷŸŹźŻżŽžſ


;; IPA extensions:
;; ɐɑɒɓɔɕɖɗɘəɚɛɜɝɞɟ
;; ɠɡɢɣɤɥɦɧɨɩɪɫɬɭɮɯ
;; ɰɱɲɳɴɵɶɷɸɹɺɻɼɽɾɿ
;; ʀʁʂʃʄʅʆʇʈʉʊʋʌʍʎʏ
;; ʐʑʒʓʔʕʖʗʘʙʚʛʜʝʞʟ
;; ʠʡʢʣʤʥʦʧʨʩʪʫʬʭʮʯ

;; Phonetic extensions:
;; ᴀᴁᴂᴃᴄᴅᴆᴇᴈᴉᴊᴋᴌᴍᴎᴏ
;; ᴐᴑᴒᴓᴔᴕᴖᴗᴘᴙᴚᴛᴜᴝᴞᴟ
;; ᴠᴡᴢᴣᴤᴥᴦᴧᴨᴩᴪᴫᴬᴭᴮᴯ
;; ᴰᴱᴲᴳᴴᴵᴶᴷᴸᴹᴺᴻᴼᴽᴾᴿ
;; ᵀᵁᵂᵃᵄᵅᵆᵇᵈᵉᵊᵋᵌᵍᵎᵏ
;; ᵐᵑᵒᵓᵔᵕᵖᵗᵘᵙᵚᵛᵜᵝᵞᵟ
;; ᵠᵡᵢᵣᵤᵥᵦᵧᵨᵩᵪᵫᵬᵭᵮᵯ
;; ᵰᵱᵲᵳᵴᵵᵶᵷᵸᵹᵺᵻᵼᵽᵾᵿ

(deftest str-unicode-math
  (testing "unicode math"
    (is (= (clj/lex-string "\"∀∁∂∃∄∅∆∇∈∉∊∋∌∍∎∏\"")
              '(StringLiteral EOF)))
    (is (= (clj/lex-string "\"U+221x∐∑−∓∔∕∖∗∘∙√∛∜∝∞∟\"")
              '(StringLiteral EOF)))))

