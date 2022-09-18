(set input (trim (read-line)))

(case (= 
  (get input) "hello")
    (print "Hi!")
    (case (= (get input) "Bye")
      (print "Ok, bye")
      (print "Something else")))