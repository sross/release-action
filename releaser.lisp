;; Copyright (c) 2008 Sean Ross
;; 
;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use,
;; copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the
;; Software is furnished to do so, subject to the following
;; conditions:
;; 
;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.
;; 
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
;; OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
;; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
;; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
;; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;; OTHER DEALINGS IN THE SOFTWARE.
;;
(defpackage :release-action
  (:use :cl :sysdef :gzip-stream :archive)
  (:export #:release-action #:create-mudball #:release-all-systems))

(in-package :release-action)

(defclass release-action (file-action) ())

(defun mudball-file (system)
  (merge-pathnames (format nil "~(~A.~A.mb~)"
                           (name-of system) (sysdef::version-string system))))

(defmethod execute ((system system) (action release-action))
  (create-mudball system))

(defun release-all-systems (&optional (*default-pathname-defaults* *default-pathname-defaults*))
  (do-systems (x)
    (with-simple-restart (continue "Ignore system ~A." x)
      (create-mudball x))))

(defun create-mudball (system &optional (output (mudball-file system)))
  (let ((*default-pathname-defaults* (component-pathname system)))  
    (with-open-gzip-file (outs output :direction :output :if-exists :supersede)
      (with-open-archive (archive outs :direction :output)
        (dolist (comp (all-files system) (finalize-archive archive))
          (let* ((file (input-file comp))
                 (entry (create-entry-from-pathname archive (enough-namestring file))))
            (write-entry-to-archive archive entry)))))
    (probe-file output)) )

;(mapcar 'probe-file (mapcar 'input-file (all-files (find-system :cl-cont))))
;(let ((*default-pathname-defaults* "~/"))
;  (create-mudball (find-system :cl-cont)))

;; EOF
