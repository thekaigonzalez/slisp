(defun return-first-arg ()
  (string-trim (position arg 1)))


(if (= (return-first-arg) (string-trim "-h"))
  (print (position arg 0) ": [-h] [--test]"))

(if (= (return-first-arg) "--test") 
  (print "Works!"))