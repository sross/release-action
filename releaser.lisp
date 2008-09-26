(defpackage :release-action
  (:use :cl :sysdef :gzip-stream :archive)
  (:export #:release-action))

(in-package :release-action)

(defclass release-action (file-action) ())

(defun output-file (system)
  (merge-pathnames (format nil "~(~A.~A.mb~)"
                           (name-of system) (sysdef::version-string system))))

(defmethod execute ((system system) (action release-action))
  (create-mudball system))

(defun create-mudball (system &optional (output (output-file system)))
  (let ((*default-pathname-defaults* (component-pathname system)))  
    (with-open-gzip-file (outs output :direction :output :if-exists :supersede)
      (with-open-archive (archive outs :direction :output)
        (dolist (comp (all-files system) (finalize-archive archive))
          (let* ((file (input-file comp))
                 (entry (create-entry-from-pathname archive (enough-namestring file))))
            (write-entry-to-archive archive entry)))))
    (probe-file output)) )

;(mapcar 'probe-file (mapcar 'input-file (all-files (find-system :cl-cont))))
(let ((*default-pathname-defaults* "~/"))
  (create-mudball (find-system :cl-cont)))

;; EOF