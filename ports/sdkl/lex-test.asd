(defun var ()
  (set a 129)
    (print "This is a variable.")
    (print "his name is a.")
    (print "a is " (get a))
    (print "now i'm going to declare it out of scope."))

(var)

(if (= (get a) nil)
  (print "Where'd a go? it used to be 129 now it's NULL!"))