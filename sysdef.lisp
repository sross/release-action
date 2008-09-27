(in-package #:sysdef-user)

(define-system :release-action ()
 (:version 0 1)
 (:components "releaser")
 (:requires :archive :gzip-stream))
