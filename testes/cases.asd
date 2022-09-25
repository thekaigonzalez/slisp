(set input (string-trim (read-line)))

(case (= 
  input "hello")
    (print "Hi!")
    (case (= input "Bye")
      (print "Ok, bye")
      (print "Something else")))