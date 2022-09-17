(set i 0)

(defun helloag ()
  (print "hello")
    (print "world")
      (print "again"))

(&thread (helloag))
