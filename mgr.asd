(defsystem "mgr"
  :version "0.1.0"
  :author "Masayuki Suzuki"
  :license "MIT"
  :depends-on (:cl-dbi :cl-ppcre)
  :components ((:module "src"
                :components
                ((:file "utility")
		 (:file "main" :depends-on ("utility")))))
  :description ""
  :in-order-to ((test-op (test-op "mgr/tests"))))

(defsystem "mgr/tests"
  :author "Masayuki Suzuki"
  :license "MIT"
  :depends-on ("mgr"
               "rove"
               )
  :components ((:module "tests"
                :components
                (
		 (:file "main"))))
  :description "Test system for mgr"
  :perform (test-op (op c) (symbol-call :rove :run c)))
