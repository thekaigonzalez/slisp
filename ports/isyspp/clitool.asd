(defun return-first-arg ()
  (trim (getf arg 1)))


(if (= (return-first-arg) (trim "-h"))
  (print (getf arg 0) ": [-h] [--test]"))

(if (= (return-first-arg) "--test") 
  (print "Works!"))