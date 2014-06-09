(defproject org.mobileink.antlr "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :source-paths ["src/clojure"]
  :resource-paths ["target/reload"]
  :java-source-paths ["src/java"]
  :javac-options ["-target" "1.7" "-source" "1.6" "-Xlint:-options"]
  ;; :target-path "target"
  :test-paths ["test/clojure"]
  ;; :test-selectors {:default (fn [m] (not (or (:integration m) (:regression m))))
  ;;                  :integration :integration
  ;;                  :regression :regression}
  :dependencies [[org.clojure/clojure "1.6.0"]
                 [org.antlr/antlr4 "4.2.2"]
                 [org.antlr/antlr4-annotations "4.2.2"]
                 [org.antlr/antlr4-runtime "4.2.2"]
                 [org.antlr/ST4 "4.0.8"]
                 [criterium "0.4.3"]
                 [byte-streams "0.1.10"]
                 [leiningen #=(leiningen.core.main/leiningen-version)]
                 [im.chit/vinyasa.reimport "0.2.0"]
                 ]
  ;; :test-selectors {:kw :kw}
  :prep-tasks [] ;; do not recompile on test
  :profiles {:dev {:dependencies [[org.clojure/tools.namespace "0.2.4"]]}}
  )

