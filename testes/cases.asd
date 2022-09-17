(set input (trim (read-line)))

(ecase (= 
  (get input) "hello")
    (print "Hi!")
    (ecase (= (get input) "Bye")
      (print "Ok, bye")
      (print "Something else")))