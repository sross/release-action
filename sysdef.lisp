(in-package #:sysdef-user)

(define-system :release-action ()
 (:version 0 1 1)
 (:components "releaser")
 (:requires :archive :gzip-stream (:mb.sysdef :version (>= 0 1 9))))
