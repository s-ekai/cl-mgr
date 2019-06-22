(defpackage mgr/tests/main
  (:use :cl
        :mgr
        :rove))
(in-package :mgr/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :mgr)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
