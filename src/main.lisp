(defpackage mgr
  (:use :cl
        :cl-dbi)
  (:import-from
        :mgr.utility
        :create)
  (:export
        :connect-db
        :disconnect-db
        :execute!
        :defup
        :defdown
        :create
        :migrate!
        :rollback!
        :create-table
        :add-column
        :drop-table
        :drop-column
        :change-column)
  )
(in-package :mgr)


;; HOW TO USE;
;; 1) create a migration file. (mgr:create migration-name)
;; 2) edit migration file.
;; 3) execute migration file. (mgr:migrate migration-file-path)
;; *4) if you want to rollback, you can do by (mgr:rollback migration-file-path). In this case you define down function.

;; migration file example
;; -----------------------------------------------
;; (in-package :cl-user)

;;(defpackage :migration-file-name
;;  (:use :cl
;;        :mgr
;;)
;;(in-package :migration-file-name)
;;
;;(defun up ()
;; (list
;;   (create-table :users)
;;   (add-column :users :name :varchar(255))
;; ))
;;
;;(defun down ()
;;  (list
;;    (drop-table :users)))
;; ----------------------------------------------

; TODO
;; https://railsguides.jp/active_record_migrations.html
;add_foreign_key
;add_reference
;add_timestamps
;create_join_table
;disable_extension
;drop_join_table
;enable_extension
;remove_column
;remove_foreign_key
;remove_index
;remove_reference
;remove_timestamps
;rename_column
;rename_index
;rename_table

(defun connect-db (&key driver name username password)
  (defvar *connection*
    (dbi:connect driver
                 :database-name name
                 :username username
                 :password password))
  )

(defun disconnect-db ()
  (dbi:disconnect *connection*)
  )

(defun execute! (sql)
    (let ((query (dbi:prepare *connection* sql)))
      (dbi:execute query))
  )

(defun migrate! (path)
  "execute up function"
  (load path)
  (mapcar #'execute! (up))
  )

(defun rollback! (path)
  "execute down function"
  (load path)
    (mapcar #'execute! (down))
    )

(defmacro defup (&body body)
  "define up function"
   `(defun up ()
       (list ,@body)
     )
  )

(defmacro defdown (&body body)
  "define down function"
    `(defun down ()
	 (list ,@body)
       )
  )

(defun create-table (name)
  "create migration file with timestamp and name"
  (format nil "CREATE TABLE ~a (id int NOT NULL AUTO_INCREMENT, PRIMARY KEY (id))" name)
)

(defun drop-table (name)
  (format nil "DROP TABLE ~a" name)
)

;; so dirty, i have to rewrite ...
(defun add-column (&key table column-name datatype null-false default-value)
  (let
    ((query (format nil "ALTER TABLE ~a ADD COLUMN ~a ~a" table column-name datatype)))
    (progn
      (if null-false
         (setf query (concatenate 'string query " NOT NUll"))
         query)
      (if default-value
         (setf query (concatenate 'string query " DEFAULT " (write-to-string default-value)))
         query))))

(defun drop-column (&key table column-name)
 (format nil "ALTER TABLE ~a drop DROP COLUMN ~a" table column-name)
)

(defun add-index (&key table column-name index-name)
 (format nil "ALTER TABLE ~a ADD INDEX ~a(~a)" table index-name column-name)
)

;; so dirty, i have to rewrite ...
(defun change-column (&key table column-name datatype null-false default-value)
  (let
    ((query (format nil "ALTER TABLE ~a MODIFY ~a ~a" table column-name datatype)))
    (progn
      (if null-false
         (setf query (concatenate 'string query " NOT NUll"))
         query)
      (if default-value
         (setf query (concatenate 'string query " DEFAULT " (write-to-string default-value)))
         query))))
