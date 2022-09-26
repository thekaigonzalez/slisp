(defun checkType (n)
  (case (= (type-of n) "number")
    (return "No")
    (print "Hello!")))

(checkType "")