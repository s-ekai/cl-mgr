(defpackage mgr.utility
  (:use :cl
	:ppcre)
  (:export :create
	   :get-migration-name))
(in-package :mgr.utility)

; TODO: use current time instead of universal time.
(defun create (name)
  (let* (
	(timestamp (write-to-string (get-universal-time)))
	 (filename (concatenate 'string timestamp "_" name ".lisp"))
	)
    (with-open-file (migration-file (merge-pathnames filename)
                     :direction :output
                     :if-exists :supersede
                     :if-does-not-exist :create)
  (format migration-file (default-migration-content filename)))

    ))

(defun default-migration-content (filename)
(format nil "
(in-package :cl-user)
(defpackage :~a
  (:use :cl
        :mgr)
)
(in-package :~a)

(defup
   (create-table \"users\")
   (add-column :table \"users\" :column-name \"name\" :datatype \"varchar(255)\")
 )

(defdown
    (drop-table \"users\")
)" filename filename))


(defun get-migration-name (path)
   (svref (nth-value 1 (ppcre:scan-to-strings "/([^\/.]+).lisp" path)) 0)
  )
